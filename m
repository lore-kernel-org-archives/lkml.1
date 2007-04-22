Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbXDVAKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbXDVAKO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 20:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXDVAKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 20:10:14 -0400
Received: from mail09.syd.optusnet.com.au ([211.29.132.190]:47979 "EHLO
	mail09.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbXDVAKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 20:10:12 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Denis Vlasenko <vda.linux@googlemail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Sun, 22 Apr 2007 10:08:49 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
References: <20070420140457.GA14017@elte.hu> <20070421160008.GA28783@elte.hu> <200704220054.58639.vda.linux@googlemail.com>
In-Reply-To: <200704220054.58639.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704221008.50367.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007 08:54, Denis Vlasenko wrote:
> On Saturday 21 April 2007 18:00, Ingo Molnar wrote:
> > correct. Note that Willy reniced X back to 0 so it had no relevance on
> > his test. Also note that i pointed this change out in the -v4 CFS
> >
> > announcement:
> > || Changes since -v3:
> > ||
> > ||  - usability fix: automatic renicing of kernel threads such as
> > ||    keventd, OOM tasks and tasks doing privileged hardware access
> > ||    (such as Xorg).
> >
> > i've attached it below in a standalone form, feel free to put it into
> > SD! :)
>
> But X problems have nothing to do with "privileged hardware access".
> X problems are related to priority inversions between server and client
> processes, and "one server process - many client processes" case.

It's not a privileged hardware access reason that this code is there. This is 
obfuscation/advertising to make it look like there is a valid reason for X 
getting negative nice levels somehow in the kernel to make interactive 
testing of CFS better by default.

-- 
-ck
