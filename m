Return-Path: <linux-kernel-owner+w=401wt.eu-S1760768AbXGDBR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768AbXGDBR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 21:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbXGDBRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 21:17:54 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:55282
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753726AbXGDBRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 21:17:53 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: Don't miss the ARM-scsi fix.
Date: Tue, 3 Jul 2007 21:17:50 -0400
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
References: <200707031503.56561.rob@landley.net> <20070703122145.447c7d2c.akpm@linux-foundation.org> <20070703193104.GA27542@flint.arm.linux.org.uk>
In-Reply-To: <20070703193104.GA27542@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032117.50397.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2007 15:31:04 Russell King - ARM Linux wrote:
> > > http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=4454/1
> > >
> > > It fixes a regression that occurred between 2.6.20 and 2.6.20-rc1. 
> > > Without it, qemu-system-arm can't use emulated SCSI drives.  It wasn't
> > > in -rc7, and the attached patch Works For Me (tm).
> >
> > Should have cc'ed Russell?
>
> It's been applied and is in my tree since yesterday.  I've no idea why
> Rob feels that he needs to pull patches out of the patch system.

Just trying to point at it and make sure that one doesn't miss 2.6.22 final, 
and let you all know that it fixes a real bug I've been seeing and 
complaining about for a while.

Reported in May:
  http://lkml.org/lkml/2007/5/10/670

Reported again in June:
  http://www.uwsg.iu.edu/hypermail/linux/kernel/0706.2/0429.html

Also poked at the qemu guys a few times.

If you've got it under control already, life is good...

Thanks,

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
