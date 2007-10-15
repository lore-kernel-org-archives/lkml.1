Return-Path: <linux-kernel-owner+w=401wt.eu-S1764182AbXJOLI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764182AbXJOLI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760465AbXJOLIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:08:44 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:50752 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760065AbXJOLIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:08:42 -0400
Message-ID: <47134A1B.8000001@linux.vnet.ibm.com>
Date: Mon, 15 Oct 2007 16:38:11 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@suse.de>, linuxppc-dev@ozlabs.org,
       stable@kernel.org
Subject: [BUG] Linux 2.6.23.1 - Open Firmware exception handler invoked
References: <20071012170140.GA18498@kroah.com>
In-Reply-To: <20071012170140.GA18498@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Open Firmware exception handler is begin invoked, on power5 lpar.

boot: 2.6.23.1
Please wait, loading kernel...
Allocated 03500000 bytes for kernel @ 01c00000
   Elf64 kernel loaded...
Loading ramdisk...
ramdisk loaded 0020d000 @ 06b00000
DEFAULT CATCH!, exception-handler=fff00300 
at   %SRR0: c00000000202705c   %SRR1: 8000000000003002 
Open Firmware exception handler entered from non-OF code

Client's Fix Pt Regs:
 00 0223100003080000 00000000018bfac0 0000000004bbeaf8 00000000018bfb48
 04 00000000018bfc90 0000000000c39a48 0000000000000000 5c3a03080000a0fa
 08 0000000000000001 0000000000000000 05910000194c0223 000000005cae0000
 0c 0000000003f1eaf8 0000000000000000 0000000000000000 0000000000000000
 10 0000000000000000 0000000000c39a48 0000000000000000 00000000018bfc90
 14 0000000000c00000 000000000020d000 0000000000000000 0000000008b00000
 18 0000000000280004 00000000018bff04 0000000000000001 0000000000000000
 1c 0000000008b00000 0000000000c39a48 c000000004d1e530 0000000008b00000
Special Regs:
    %IV: 00000300     %CR: 44000028    %XER: 00000000  %DSISR: 08000000 
  %SRR0: c00000000202705c   %SRR1: 8000000000003002 
    %LR: c000000002027428    %CTR: c0000000020273f0 
   %DAR: 05910000194c02eb 
Virtual PID = 0 
PFW: Unable to send error log!
 ofdbg
0 > 

# cat /proc/cpuinfo 
processor       : 0
cpu             : POWER5+ (gs)
clock           : 1498.500000MHz
revision        : 2.0 (pvr 003b 0200)

processor       : 1
cpu             : POWER5+ (gs)
clock           : 1498.500000MHz
revision        : 2.0 (pvr 003b 0200)

timebase        : 187199000
platform        : pSeries
machine         : CHRP IBM,9133-55A
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
