Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbZG0KM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbZG0KM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 06:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbZG0KM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 06:12:27 -0400
Received: from fed1rmmtao104.cox.net ([68.230.241.42]:34294 "EHLO
	fed1rmmtao104.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbZG0KM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 06:12:26 -0400
X-VR-Score: -180.00
X-Authority-Analysis: v=1.0 c=1 a=-eSCxmgh_CwA:10 a=VwQbUJbxAAAA:8
 a=kviXuzpPAAAA:8 a=ZiUfDDZ0lD_SlehD6JsA:9 a=OKTELhbLhEV0s8_JXN2GnIB0UI8A:4
 a=4vB-4DCPJfMA:10 a=Zh68SRI7RUMA:10
X-CM-Score: 0.00
From: Duncan <1i5t5.duncan@cox.net>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #13750] Load average flatlines after returning from hibernate
Date: Mon, 27 Jul 2009 02:21:24 -0700
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4; KDE/4.2.4; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.DfD.oHObKB@chimera> <1248675666.6987.1415.camel@twins>
In-Reply-To: <1248675666.6987.1415.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907270221.24667.1i5t5.duncan@cox.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 July 2009 23:21:06 Peter Zijlstra wrote:
> On Sun, 2009-07-26 at 22:28 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13750
> > Subject		: Load average flatlines after returning from hibernate
> > Submitter	: Duncan <1i5t5.duncan@cox.net>
> > Date		: 2009-07-09 15:14 (18 days old)
>
> commit 6301cb95c119ebf324bb96ee226fa9ddffad80a7
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Jul 17 14:15:47 2009 +0200
>
>     sched: fix nr_uninterruptible accounting of frozen tasks really
>
>
> commit a468d389349a7560249b355cdb6d2097ea1616c9
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Jul 17 14:15:46 2009 +0200
>
>     sched: fix load average accounting vs. cpu hotplug

[replied to all]

That's presumably correct, as rc4 (on-tag at last git pull) resolved it.

Just updated the bug.

(I didn't know whether CODE_FIX or PATCH_ALREADY_AVAILABLE was correct, and 
the status link is to the generic bugzilla resolutions, so not much help.  I 
picked CODE_FIX.  I guess that's the next bug I file, on bugzilla.kernel.org 
itself.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
