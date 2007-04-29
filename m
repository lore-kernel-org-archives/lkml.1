Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbXD2Qoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbXD2Qoi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 12:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbXD2Qoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 12:44:38 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:52214 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbXD2Qoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 12:44:37 -0400
Message-ID: <4634CB45.70408@s5r6.in-berlin.de>
Date: Sun, 29 Apr 2007 18:43:49 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [patch 5/9] IEEE1394: Spinlock initializer cleanup
References: <20070429154221.159165000@linutronix.de>> <20070429154337.581254000@linutronix.de>>
In-Reply-To: <20070429154337.581254000@linutronix.de>>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> --- linux-2.6.orig/drivers/ieee1394/ieee1394_transactions.c
> +++ linux-2.6/drivers/ieee1394/ieee1394_transactions.c
> @@ -32,7 +32,7 @@
>  #ifndef HPSB_DEBUG_TLABELS
>  static
>  #endif
> -spinlock_t hpsb_tlabel_lock = SPIN_LOCK_UNLOCKED;
> +DEFINE_SPINLOCK(hpsb_tlabel_lock);

We've got already an identical patch from Milind Arun Choudhary,
http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git;a=commitdiff;h=ca79b9d41152ff8605ed5503fd4cbfe0ea60ee7f
in linux1394-2.6.git/master and hence in -mm.  It'll be part of the post
2.6.21 pull request I'll send out RSN, unless your patch bypasses me
somehow.
-- 
Stefan Richter
-=====-=-=== -=-- ===-=
http://arcgraph.de/sr/
