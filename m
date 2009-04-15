Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZDOPln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZDOPln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZDOPld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:41:33 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:42452 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbZDOPlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:41:32 -0400
Date: Wed, 15 Apr 2009 11:41:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BISECTED] EEE PC hangs when booting off battery
In-reply-to: <20090414050252.GA4361@mercury.localdomain>
Message-id: <alpine.LFD.2.00.0904151140230.5664@localhost.localdomain>
References: <49E065CF.6040408@tuffmail.co.uk> <49E1ADAE.2030103@tuffmail.co.uk>
 <49E1E89D.7040502@tuffmail.co.uk> <200904131315.55519.bjorn.helgaas@hp.com>
 <49E3990C.6040303@tuffmail.co.uk> <20090414050252.GA4361@mercury.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Apr 2009, Ben Gamari wrote:

> On Mon, Apr 13, 2009 at 08:57:00PM +0100, Alan Jenkins wrote:
> > Bjorn Helgaas wrote:
> > However, I now find that's not quite right.  It only works (i.e. doesn't
> > hang) if I remove the battery as well as plugging it into the wall.  If
> > I have the battery in, it hangs.
> 
> I seem to have a similar issue with master which occurs regardless of
> whether the battery is in on my Dell Latitude D830.  Here is the
> backtrace,

Does it go away for you in 2.6.30-rc2 like it did for Alan?

thanks,
-Len Brown, Intel Open Source Technology Center

> input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:37/input/i6
> ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)                  
> ACPI Warning (nspredef-0437): \_SB_.PCI0.VID2._DOD: Return Package has no eleme]
> input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:3c/input/i7
> ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)                  
> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0               
> SysRq : Show backtrace of all active CPUs                                       
> CPU1:                                                                           
> CPU 1:                                                                          
> Modules linked in: i915 drm i2c_algo_bit cfbcopyarea i2c_core cfbimgblt video o]
> Pid: 0, comm: swapper Not tainted 2.6.30-rc1ben #54 Latitude D830               
> RIP: 0010:[<ffffffff8126c488>]  [<ffffffff8126c488>] acpi_idle_enter_bm+0x28e/00
> RSP: 0018:ffff88011fb0fe88  EFLAGS: 00000246                                    
> RAX: 000000000000eca0 RBX: ffff88011fb0fee8 RCX: 0000000000000000               
> RDX: ffff88002803a000 RSI: 0000000516143023 RDI: ffff88002804d6c0               
> RBP: ffffffff8101180e R08: ffffffffff762325 R09: ffff88011fb09058               
> R10: ffff88011fb09018 R11: ffff880028049430 R12: 000000073446f694               
> R13: ffff88011fb0fe08 R14: 00000000000019d2 R15: ffff88011fb0fe18               
> FS:  0000000000000000(0000) GS:ffff88002803a000(0000) knlGS:0000000000000000    
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b                               
> CR2: 00007fff6d9cab78 CR3: 0000000000201000 CR4: 00000000000006e0               
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000               
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400               
> Call Trace:                                                                     
>  [<ffffffff8126c481>] ? acpi_idle_enter_bm+0x287/0x2d0                          
>  [<ffffffff8133f949>] ? cpuidle_idle_call+0x93/0xca                             
>  [<ffffffff8100fd20>] ? cpu_idle+0x64/0xcd                                      
>  [<ffffffff813f5326>] ? start_secondary+0x1a1/0x1a6                             
> 
> 
> Hope this helps. Let me know if I can do anything else. Thanks!
> 
> - ben
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
