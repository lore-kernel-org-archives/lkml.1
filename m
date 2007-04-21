Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbXDUBeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbXDUBeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 21:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbXDUBeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 21:34:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58135 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754035AbXDUBep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 21:34:45 -0400
Date: Sat, 21 Apr 2007 03:34:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Marcos Pinto <markybob@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
       Alan Cox <alan@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: 2.6.20.7 locking up hard on boot
Message-ID: <20070421013454.GB4016@stusta.de>
References: <62eb359a0704201747ma376567kda671d6fa98b7409@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <62eb359a0704201747ma376567kda671d6fa98b7409@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 07:47:13PM -0500, Marcos Pinto wrote:
> I'm not subscribed, so please personally CC me any answers/comments.
> Thank you.
>
> While booting, (AMD64 Turion x2) 2.6.20.7 kernel locks up hard.  The
> last kernel that I tried, 2.6.18.8, worked perfectly without any
> trickery.  2.6.20.7 only boots up with "acpi=off" being added to the
> kernel line.  Note that 2.6.18.8 works perfectly with acpi on, which
> is really the
> only way I can run this box because with "acpi=off" it overheats and 
> freezes.
> Please let me know if there's anything else that I could do to help with 
> this.
>
>
> Here's what's on the screen when it happens:
>
> Brought up 2 CPUs
> testing NMI watchdog ... OK.
> Disabling vsyscall due to  use of PM timer
> time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
> time.c: Detected 1808.264 MHz processor.
> migration_cost=281
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: Using MMCONFIG at e0000000
> PCI: No mmconfig possible on device 00:18
> PCI: No mmconfig possible on device 07:05
> ACPI: Interpreter enabled
> ACPI: Using IOAPIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
> 0000:00:0d.0: cannot adjust BAR0 (not I/O)
> 0000:00:0d.0: cannot adjust BAR1 (not I/O)
>...

Does 2.6.20.3 boot with ACPI enabled?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

