Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbYBHDH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbYBHDH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 22:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbYBHDHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 22:07:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45655 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756658AbYBHDHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 22:07:49 -0500
Date: Thu, 7 Feb 2008 19:04:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alasdair G Kergon <agk@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Brian Wood <brian.j.wood@intel.com>, Daniel Walker <dwalker@mvista.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Jonathan Brassow <jbrassow@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Milan Broz <mbroz@redhat.com>, Paul Jimenez <pj@place.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>, Vasily Averin <vvs@sw.ru>,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Milan Broz <mbroz@redhat.com>
Subject: Re: [git pull] device-mapper update for 2.6.25
Message-Id: <20080207190447.b4dcfe0c.akpm@linux-foundation.org>
In-Reply-To: <20080208024532.GC24157@agk.fab.redhat.com>
References: <20080208024532.GC24157@agk.fab.redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008 02:45:32 +0000 Alasdair G Kergon <agk@redhat.com> wrote:

>       dm: move deferred bio flushing to workqueue

To my unpracticed eye this one looks fairly fundamental.  Unfortunately the
changelog:

  Add a single-thread workqueue for each mapped device and move flushing
  of the lists of pushback and deferred bios to this new workqueue.

tells us nothing of the reasons for this change.  (It should have done so!)

It _looks_ pretty unscalable.  Perhaps these deferred BIOs don't happen
very often?

