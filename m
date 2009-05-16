Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZEPVEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZEPVEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 17:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZEPVD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 17:03:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43604 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbZEPVD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 17:03:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 2.6.30-rc4: microcode: failed to init CPU1
Date: Sat, 16 May 2009 23:04:00 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
References: <1241633352.4524.3.camel@localhost.localdomain>
In-Reply-To: <1241633352.4524.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905162304.01226.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 May 2009, Thomas Meyer wrote:
> Hi,
> 
> With 2.6.30-rc4 I see this after resume from ram or disk. Here log from resume from disk:
> 
> [ 6643.757890] Breaking affinity for irq 23
> [ 6643.759029] kvm: disabling virtualization on CPU1
> [ 6643.859360] CPU 1 is now offline
> [ 6643.859366] SMP alternatives: switching to UP code
> [ 6643.869609] CPU1 is down
> [ 6643.869682] Extended CMOS year: 2000
> [ 6643.869786] PM: Creating hibernation image: 
> [ 6643.872676] PM: Need to copy 124075 pages
> [ 6643.872676] Intel machine check architecture supported.
> [ 6643.872676] Intel machine check reporting enabled on CPU#0.
> [ 6643.872676] PM: Restoring platform NVS memory
> [ 6643.872676] Extended CMOS year: 2000
> [ 6643.872676] Enabling non-boot CPUs ...
> [ 6643.872676] SMP alternatives: switching to SMP code
> [ 6643.879652] CPU 1 irqstacks, hard=c20d6000 soft=c20d7000
> [ 6643.879661] Booting processor 1 APIC 0x1 ip 0x6000
> [ 6643.869076] Initializing CPU#1
> [ 6643.869076] Calibrating delay using timer specific routine.. 3663.43 BogoMIPS (lpj=6103090)
> [ 6643.869076] CPU: L1 I cache: 32K, L1 D cache: 32K
> [ 6643.869076] CPU: L2 cache: 2048K
> [ 6643.869076] CPU: Physical Processor ID: 0
> [ 6643.869076] CPU: Processor Core ID: 1
> [ 6643.869076] Intel machine check architecture supported.
> [ 6643.869076] Intel machine check reporting enabled on CPU#1.
> [ 6643.973311] CPU1: Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
> [ 6643.973364] kvm: enabling virtualization on CPU1
> [ 6643.973521] Switched to high resolution mode on CPU 1
> [ 6643.982900] microcode: failed to init CPU1
> [ 6643.983528] CPU1 is up
> [ 6643.984529] ACPI: Waking up from system sleep state S4
> [ 6644.290917] pci 0000:00:1e.0: power state changed by ACPI to D0
> [ 6644.291103] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
> [ 6644.291139] ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800001, writing 0x2800005)
> [ 6644.291187] ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00003, writing 0x2b00007)
> [ 6644.297593] pci 0000:00:07.0: PME# disabled
> 
> Is this an error/problem?

Not sure.

CCing the people who have worked with the Intel microcode code recently.

Thanks,
Rafael
