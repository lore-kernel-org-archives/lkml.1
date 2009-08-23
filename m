Return-Path: <linux-kernel-owner+w=401wt.eu-S934102AbZHWUQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbZHWUQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 16:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934066AbZHWUQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 16:16:47 -0400
Received: from ppp-136-251.adsl.restena.lu ([158.64.136.251]:56577 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933931AbZHWUQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 16:16:46 -0400
Date: Sun, 23 Aug 2009 22:16:21 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andy Whitcroft <apw@canonical.com>,
       "Ed L. Cashin" <ecashin@coraid.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/1] aoe: ensure we initialise the request_queue
 correctly
Message-ID: <20090823221621.25fdb491@neptune.home>
In-Reply-To: <20090823110021.28fc40dc@neptune.home>
References: <1250872904-10993-1-git-send-email-apw@canonical.com>
	<20090822112103.49174d6b@neptune.home>
	<200908222352.07482.rjw@sisk.pl>
	<20090823110021.28fc40dc@neptune.home>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 August 2009 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> At least this uninitialized object warning already existed with
> 2.6.31-rc1. More bisect-like details later today.

Hm, the NULL bio->bi_io_vec on unmount seems picky as to when it wants
to be reproduced, half a day bisecting on a spare system without
result...

I got it on one system with -rc1, on spare system a bisect
v2.6.30..v2.6.31-rc1 was always good. Will have to retry with complete,
not simplified config on one of the two systems where I got that trace.

FYI: someone else did report it on 2.6.30-gentoo-r4 which is
similar to 2.6.30.x, see http://bugs.gentoo.org/show_bug.cgi?id=281929

Bruno
