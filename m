Return-Path: <linux-kernel-owner+w=401wt.eu-S1161128AbXBUUiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161128AbXBUUiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161146AbXBUUiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:38:19 -0500
Received: from www.osadl.org ([213.239.205.134]:50444 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161128AbXBUUiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:38:18 -0500
Subject: Re: Linux 2.6.21-rc1
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Daniel Walker <dwalker@mvista.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <1172088050.8577.71.camel@imap.mvista.com>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
	 <1172077664.25076.75.camel@localhost.localdomain>
	 <1172078340.8577.43.camel@imap.mvista.com>
	 <1172079671.25076.80.camel@localhost.localdomain>
	 <1172079523.8577.48.camel@imap.mvista.com>
	 <1172081931.25076.95.camel@localhost.localdomain>
	 <1172082200.8577.56.camel@imap.mvista.com>
	 <1172085792.25076.119.camel@localhost.localdomain>
	 <1172088050.8577.71.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 21:43:23 +0100
Message-Id: <1172090603.25076.127.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 12:00 -0800, Daniel Walker wrote:
> There's a compile failure during my bisect.
> 
> distcc[3863] ERROR: compile /tmp//hrtimer.tmp.dwalker1.3795.i on dwalker3/120 failed
> kernel/hrtimer.c: In function 'hrtimer_cpu_notify':
> kernel/hrtimer.c:884: warning: implicit declaration of function 'clockevents_notify'
> kernel/hrtimer.c:884: error: 'CLOCK_EVT_NOTIFY_CPU_DEAD' undeclared (first use in this function)
> kernel/hrtimer.c:884: error: (Each undeclared identifier is reported only once 
> kernel/hrtimer.c:884: error: for each function it appears in.)
> drivers/ide/setup-pci.c: In function 'ide_scan_pcibus':
> drivers/ide/setup-pci.c:866: warning: ignoring return value of '__pci_register_driver', declared with attribute warn_unused_result
> make[1]: *** [kernel/hrtimer.o] Error 1

hrmpf. we made it bisectable at some point.

	tglx


