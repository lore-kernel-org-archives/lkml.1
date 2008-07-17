Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbYGQDPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbYGQDPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 23:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbYGQDPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 23:15:05 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:35981 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752654AbYGQDPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 23:15:04 -0400
Date: Wed, 16 Jul 2008 23:15:02 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080717031502.GA18760@bromo.msbb.uc.edu>
References: <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com> <dd18b0c30807160050r5b10908fiffc2a4b464abe5f3@mail.gmail.com> <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com> <20080716140810.GA2861@bromo.msbb.uc.edu> <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com> <86802c440807161535n3a4d6891n6f7c16bd4e1f19c3@mail.gmail.com> <20080717004004.GA17792@bromo.msbb.uc.edu> <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com> <20080717023538.GA18329@bromo.msbb.uc.edu> <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YH,
   I meant that pci=nommconf doesn't allow the boot to complete
under 2.6.26. I haven't tried that under 2.6.25.10, however the
2.6.5.10 kernel should be using mmconfig since I see...

PCI: Using MMCONFIG at f0000000 - ffffffff
PCI: Using configuration type 1
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0

                          Jack

On Wed, Jul 16, 2008 at 07:59:16PM -0700, Yinghai Lu wrote:
> On Wed, Jul 16, 2008 at 7:35 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> > Yinghai,
> >   As I expected pci=mmconf doesn't allow the MacBook Pro to boot.
> 
> you mean pci=nommconf doesn't work too?
> 
> 2.6.25 is not using mmconf in your system.
> 
> lspci -vvxxxx could tell, if it print out 256 or 4096 pci conf space.
> 
> YH
