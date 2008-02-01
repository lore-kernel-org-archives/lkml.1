Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbYBAUF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbYBAUF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbYBAUFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:05:21 -0500
Received: from mail.gmx.net ([213.165.64.20]:59695 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753359AbYBAUFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:05:20 -0500
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 01 Feb 2008 21:05:18 +0100
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <20080201191119.GI18688@csn.ul.ie>
Message-ID: <20080201200518.174050@gmx.net>
MIME-Version: 1.0
References: <20080201184254.174020@gmx.net> <20080201191119.GI18688@csn.ul.ie>
Subject: Re: Commit for mm/page_alloc.c breaks boot process on my machine
To: Mel Gorman <mel@csn.ul.ie>
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/QvA8b9f/QqAhul94nIFw3F1gzzbhp+1/Ws5BJ5A
 lnuf1xQ3a2nB7GBdmZm0E4i7pykO4Wj9bkRw== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: TUyRdslrIydmNgtvKWdrEklSa2FkZpUT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
> Datum: Fri, 1 Feb 2008 19:11:19 +0000
> Von: Mel Gorman <mel@csn.ul.ie>
> An: Gerhard Pircher <gerhard_pircher@gmx.net>
> CC: linux-kernel@vger.kernel.org
> Betreff: Re: Commit for mm/page_alloc.c breaks boot process on my machine

> With this patch, early boot would use pages from lower PFNs. Without the
> patch, it would use memory from higher PFNs. That is the only real
> difference.
> 
> 1. Is there any chance that all of your memory is not being properly
>    initialised?
Do you mean uninitialized hardware? That shouldn't be a problem, since
older kernels (e.g. 2.6.19 with platform patches for arch/ppc) are running
fine.

> 2. Any chance of seeing a dmesg log?
That's a little bit of a problem. The kernel log in memory doesn't show
any kernel oops, but is also fragmented (small fragments seem to have been
overwritten with 0x0). I could extract it by using the U-boot firmware,
but that takes some time, as the serial console is not yet working.
I tried to boot the kernel with 512MB and 1.5GB RAM. The amount of memory
doesn't have any effect and the amount of memory is reported correctly
in the kernel log.

> 3. If you boot with the patch reverted and then do something to consume
> all memory like build loads of kernel trees simultaneously, do you see
> any problems?
Well, I can't answer this question. The kernel currently locks up when
loading the INIT program. But that is another problem (I still have to
bisect it) and doesn't seem to be related to this problem.

Thanks for your help!

Gerhard
-- 
GMX FreeMail: 1 GB Postfach, 5 E-Mail-Adressen, 10 Free SMS.
Alle Infos und kostenlose Anmeldung: http://www.gmx.net/de/go/freemail
