Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbZJNINs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbZJNINs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 04:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbZJNINs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 04:13:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43085 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757717AbZJNINq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 04:13:46 -0400
Date: Wed, 14 Oct 2009 10:13:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alex Chiang <achiang@hp.com>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091014081309.GM9228@kernel.dk>
References: <20091012120620.GG9228@kernel.dk> <20091012145254.GA1517@kroah.com> <20091012145700.GJ9228@kernel.dk> <4AD34494.7020602@rtr.ca> <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013172731.GB22797@ldl.fc.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13 2009, Alex Chiang wrote:
> * Jens Axboe <jens.axboe@oracle.com>:
> > > > >> On Mon, Oct 12 2009, Greg KH wrote:
> > > > >>> Can you try the acpiphp driver instead?  That's usually the
> > > > >>> driver you want to use for "modern" systems (i.e. anything
> > > > >>> made in the past 5 years.)
> > > > >>
> > > > >> I should have mentioned that I tried that too. It doesn't
> > > > >> complain, but I don't see my cards anywhere afterwards. I'm
> > > > >> a hotplug newbie, do I need to do anything else?
> > > 
> > > Can you modprobe acpiphp with debug=1? And send the output?
> > 
> > acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> > acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:05.0
> > acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:08:00
> > acpiphp: Slot [1] registered
> > acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:07.0
> > acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:0b:00
> > acpiphp: Slot [2] registered
> > acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:07.0
> > acpiphp_glue: found ACPI PCI Hotplug slot 6 at PCI 0000:84:00
> > acpiphp: Slot [6] registered
> > acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:09.0
> > acpiphp_glue: found ACPI PCI Hotplug slot 7 at PCI 0000:87:00
> > acpiphp: Slot [7] registered
> > acpiphp_glue: Bus 0000:87 has 1 slot
> > acpiphp_glue: Bus 0000:84 has 1 slot
> > acpiphp_glue: Bus 0000:0b has 1 slot
> > acpiphp_glue: Bus 0000:08 has 1 slot
> > acpiphp_glue: Total 4 slots
> 
> You mentioned in another mail that you echoed 1 into the various
> slots' power files.
> 
> Did you do that after modprobing acpiphp with debug=1?
> 
> If so, there should be debug output when you try and turn them
> on.

It produces:

acpiphp: enable_slot - physical_slot = 1
acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
acpiphp: enable_slot - physical_slot = 2
acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
acpiphp: enable_slot - physical_slot = 6
acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
acpiphp: enable_slot - physical_slot = 7
acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL

I have a card in one of the slots only this time.

> Also, quick dummy check, you are trying to power on populated
> slots, right? :)

Yes :-)

> Can you send the output of lspci -vv? And I like the output of
> lspci -vt as well... Both before and after loading acpiphp
> please.

Send privately.

-- 
Jens Axboe

