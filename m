Return-Path: <linux-kernel-owner+w=401wt.eu-S1767390AbXDEWoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767390AbXDEWoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767391AbXDEWoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:44:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56146 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767390AbXDEWop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:44:45 -0400
Date: Thu, 5 Apr 2007 15:43:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: root@programming.kicks-ass.net
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       a.p.zijlstra@chello.nl, nikita@clusterfs.com
Subject: Re: [PATCH 08/12] mm: fixup possible deadlock
Message-Id: <20070405154350.0ea203ea.akpm@linux-foundation.org>
In-Reply-To: <20070405174319.617238739@programming.kicks-ass.net>
References: <20070405174209.498059336@programming.kicks-ass.net>
	<20070405174319.617238739@programming.kicks-ass.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 19:42:17 +0200
root@programming.kicks-ass.net wrote:

> When the threshol is in the order of the per cpu inaccuracies we can
> deadlock by not receiveing the updated count,

That explanation is a bit, umm, terse.

> introduce a more expensive
> but more accurate stat read function to use on low thresholds.

Looks like percpu_counter_sum().
