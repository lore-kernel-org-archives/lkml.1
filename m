Return-Path: <linux-kernel-owner+w=401wt.eu-S932376AbXBPO0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbXBPO0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367AbXBPO0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:26:41 -0500
Received: from [221.217.24.227] ([221.217.24.227]:34150 "EHLO
	freya.yggdrasil.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932375AbXBPO0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:26:40 -0500
Date: Fri, 16 Feb 2007 22:28:30 +0800
From: "Adam J. Richter" <adam@yggdrasil.com>
Message-Id: <200702161428.l1GESUw9008969@freya.yggdrasil.com>
To: linux-kernel@vger.kernel.org
Subject: Clock running at half speed in 2.6.20?
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	My system clock runs at approximately half speed in
linux-2.6.20, 2.6.20-git10 and 2.6.20-git11.  That is, it takes about
two hours for "date" to report that one hour has elapsed.  "hwclock"
returns the correct time, of course.

	I do not have this problem in linuux 2.6.18.1.  I will try to
narrow down the kernel version where this problem began.

	The motherboard in question is an asus p4v8000-x, running a
2.8GHz Pentium 4 that has two hyperthreads, which I suspect may be the
problem.  I am just guessing, but perhaps some piece of code thinks
the two hyperthreads are separate CPU's receving twice as many clock
interrupts total.  I expect to try to some experimentation to check
this theory.

	For what it's worth, I am running CONFIG_PREEMPT=y,
CONFIG_PREEMPT_BKL=y, CONFIG_HZ=1000.

	If there is a more specific mailing list for discussing this
problem, I would be interested in knowning about it.  The MAINTAINERS
file lists several components with the word "clock" in them, but I
believe that all are for drivers for hardware clocks or high
resolution timer extensions.  I tried a quick search of the
linux-kernel mailing list for "clock" in the subject line, and did not
notice anything that seemed like a match to this problem.

	I will post more information as I collect it, but I am posting
this bug report now in case this problem rings a bell for anyone.

Adam Richter
