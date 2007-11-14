Return-Path: <linux-kernel-owner+w=401wt.eu-S1762426AbXKNW1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762426AbXKNW1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbXKNW1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:27:00 -0500
Received: from gate.crashing.org ([63.228.1.57]:55629 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbXKNW1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:27:00 -0500
Subject: Re: [PATCH] prom_find_machine_type typo breaks pSeries lpar boot
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "B. N. Poornima" <poornima@in.ibm.com>
Cc: Nathan Lynch <ntl@pobox.com>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       ppc64 dev list <linuxppc64-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Martin J. Bligh" <mbligh@mbligh.org>, roland@topspin.com
In-Reply-To: <473AE9BE.8070001@in.ibm.com>
References: <374360000.1117810369@[10.10.2.4]> <52is0vwd49.fsf@topspin.com>
	 <20050603182725.GB11355@otto> <52vf4vuum5.fsf@topspin.com>
	 <20050603192525.GC11355@otto> <1117839500.31082.188.camel@gaston>
	 <473AE9BE.8070001@in.ibm.com>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 09:13:02 +1100
Message-Id: <1195078382.28865.49.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-14 at 17:57 +0530, B. N. Poornima wrote:
> Benjamin Herrenschmidt wrote:
> > On Fri, 2005-06-03 at 14:25 -0500, Nathan Lynch wrote:
> >   
> >> Typo in prom_find_machine_type from Ben's recent patch "ppc64: Fix
> >> result code handling in prom_init" prevents pSeries LPAR systems from
> >> booting.
> >>
> >> Tested on a pSeries 570 and OpenPower 720 (both Power5 LPAR).
> >>     
> >
> > Damn ! I'm certain I tested it on P5 ! I must have forgotten to "quilt
> > ref" before sending the patch (as I did notice this typo and fixed it
> > just before sending).
> >
> > Sorry!
> >
> > Ben.
> >
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> >
> >   
> Hello,
> Same typo has creped in again from 2.6.17 kernel onwards and causing 
> open firmware exception in pSeries systems.

Can you forward the patch ?

> =====================================================================================
> 
> Welcome to yaboot version 10.1.21-r910.SuSE
> booted from '/vdevice/v-scsi@30000003/disk@8100000000000000'
> Enter "help" to get some basic usage information
> boot: 2.6.23.1
> Please wait, loading kernel...
> Allocated 03500000 bytes for kernel @ 01c00000
>    Elf64 kernel loaded...
> Loading ramdisk...
> ramdisk loaded 0020d000 @ 06b00000
> DEFAULT CATCH!, exception-handler=fff00300 
> at   %SRR0: c00000000202705c   %SRR1: 8000000000003002 
> Open Firmware exception handler entered from non-OF code
> 
> Client's Fix Pt Regs:
>  00 0223100003080000 00000000018bfac0 0000000004bbeaf8 00000000018bfb48
>  04 00000000018bfc90 0000000000c39a48 0000000000000000 5c3a03080000a0fa
>  08 0000000000000001 0000000000000000 05910000194c0223 000000005cae0000
>  0c 0000000003f1eaf8 0000000000000000 0000000000000000 0000000000000000
>  10 0000000000000000 0000000000c39a48 0000000000000000 00000000018bfc90
>  14 0000000000c00000 000000000020d000 0000000000000000 0000000008b00000
>  18 0000000000280004 00000000018bff04 0000000000000001 0000000000000000
>  1c 0000000008b00000 0000000000c39a48 c000000004d1e530 0000000008b00000
> Special Regs:
>     %IV: 00000300     %CR: 44000028    %XER: 00000000  %DSISR: 08000000 
>   %SRR0: c00000000202705c   %SRR1: 8000000000003002 
>     %LR: c000000002027428    %CTR: c0000000020273f0 
>    %DAR: 05910000194c02eb 
> Virtual PID = 0 
> PFW: Unable to send error log!
>  ofdbg
> 0 > 
> 
> ===========================================================================================
> The patch that is provided solves the problem.
> 
> Regards,
> Poornima.

