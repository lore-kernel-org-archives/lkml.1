Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYDUVdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYDUVdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbYDUVcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:32:15 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49728 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbYDUVcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:32:13 -0400
Date: Tue, 22 Apr 2008 00:31:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, bob.picco@hp.com
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC: 2.6 patch] MAINTAINERS: remove HPET entries
Message-ID: <20080421213141.GG2633@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.10.0804042019210.3224@apollo.tec.linutronix.de> <47F69621.3080105@garzik.org> <alpine.LFD.1.10.0804042339020.3224@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804042339020.3224@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 11:39:44PM +0200, Thomas Gleixner wrote:
> On Fri, 4 Apr 2008, Jeff Garzik wrote:
> > Thomas Gleixner wrote:
> > > 1) drivers/char/hpet.c
> > >    include/linux/hpet.h
> > > 
> > >    due to the revert of the HPET irq assignemt, which was only affects x86.
> > 
> > 
> > Related to this...  check out jgarzik/misc-2.6.git#irq-cleanups and
> > #irq-remove for my set of patches that remove the 'irq' argument from all irq
> > handlers.
> > 
> > I have a couple cleanup patches for HPET that should go in prior to the big
> > "remove irq argument" massive change (even if people don't want to remove the
> > 'irq' argument ultimately, the cleanup is still useful)
> > 
> > Who is the HPET maintainer these days, if anyone?
> 
> Dunno. It usually ends up in one of my git sinks :(

So what about the patch below to avoid patches ending up at the wrong 
people?

> Thanks,
> 	tglx

cu
Adrian


<--  snip  -->


We had 4 different MAINTAINERS entries for HPET, but effectively Thomas 
currently is the maintainer.

Remove these entries - the already existing entry for X86 should be 
better for handling to.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 MAINTAINERS |   20 --------------------
 1 file changed, 20 deletions(-)

4e4d08631d04846823443559dce6feaab4ce46f3 diff --git a/MAINTAINERS b/MAINTAINERS
index 45b86ab..b0c075a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1840,26 +1840,6 @@ P:	Carlos Corbacho
 M:	carlos@strangeworlds.co.uk
 S:	Odd Fixes
 
-HPET:	High Precision Event Timers driver (hpet.c)
-P:	Clemens Ladisch
-M:	clemens@ladisch.de
-S:	Maintained
-
-HPET:	i386
-P:	Venkatesh Pallipadi (Venki)
-M:	venkatesh.pallipadi@intel.com
-S:	Maintained
-
-HPET:	x86_64
-P:	Vojtech Pavlik
-M:	vojtech@suse.cz
-S:	Maintained
-
-HPET:	ACPI hpet.c
-P:	Bob Picco
-M:	bob.picco@hp.com
-S:	Maintained
-
 HPFS FILESYSTEM
 P:	Mikulas Patocka
 M:	mikulas@artax.karlin.mff.cuni.cz

