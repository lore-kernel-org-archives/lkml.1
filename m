Return-Path: <linux-kernel-owner+w=401wt.eu-S1761052AbXFQWiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761052AbXFQWiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 18:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbXFQWir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 18:38:47 -0400
Received: from ns3.system-techniques.com ([204.91.156.41]:60435 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbXFQWiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 18:38:46 -0400
Date: Sun, 17 Jun 2007 15:38:45 -0700 (PDT)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: Re: Machine Check Exception: 0...04
In-Reply-To: <Pine.LNX.4.64.0706160948510.29686@filesrv1.baby-dragons.com>
Message-ID: <Pine.LNX.4.64.0706171535160.6316@filesrv1.baby-dragons.com>
References: <Pine.LNX.4.64.0706160948510.29686@filesrv1.baby-dragons.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.8 (ns3.baby-dragons.com [204.91.156.41]); Sun, 17 Jun 2007 22:38:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 	Hello All ,  As a continuation .

On Sat, 16 Jun 2007, Mr. James W. Laferriere wrote:
> 	Hello All ,  Does anoyone know howto identify a cause for these(*) ?
> 	Or of any tools to help in the identification of the cause ?
> 	So far the Machine checks only happen when I am running bonnie++ 
> against
> 	my software raid6 array .
>
> 	I have done everything I know to do to attempt to ascertain what is
> 	causing the machine checks .
> 	ie:
> 1)	memtest86+ for days ,  no errors .
> 2)	cpuburnP6 ,  The tests run were 'cpuburnP6 E' & 'cpuburnP6 H' for ~
> 	60 minutes each .  All CPU's & HT were at 96+<->100% for 60+ Minutes 
> ,
> 	no excessive heating or lockups . In single user mode of course .
> 	I know cpuburn is old but it can excersize the comms between l1 & cpu
> 	& l1 & l2 -> cpu if done right .
>
> (*)
> CPU 5: Machine Check Exception: 0000000000000004
> CPU 4: Machine Check Exception: 0000000000000004
> Kernel panic - not syncing: Unable to continue
> <system reboots>
>
> root@(none):~ # uname -a
> Linux (none) 2.6.21.5 #1 SMP Fri Jun 15 04:37:23 UTC 2007 i686 pentium4 i386 
> GNU/Linux
>
> Complete serial console log of a boot to single user mode is here .
>
> http://www.baby-dragons.com/test-2.6.21.5-mptscsi-4.00.10.00-2007006161326.log
>

 	Hopefully more useful information .  Again only if I am doing any HEAVY
 	disk activity ie: bonnie++ .
 	I am not able to find a tool to disassamble the EIP: portion of the
 	CPU 4: output .

eth2: after: tx_done_idx=125 free_idx=3 cmdsts=800005ea
CPU 5: Machine Check Exception: 0000000000000004
CPU 4: Machine Check Exception: 0000000000000004
CPU 4: EIP: c0100c72 EFLAGS: 00000246
         eax: 00000000 ebx: 00000000 ecx: 00000000 edx: 00000000
         esi: 00000000 edi: f7c58000 ebp: f7c59f68 esp: f7c59f5c
Kernel panic - not syncing: Unable to continue

 		Tia ,  JimL
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
