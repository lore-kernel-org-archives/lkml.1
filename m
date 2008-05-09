Return-Path: <linux-kernel-owner+w=401wt.eu-S1760382AbYEIQ6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382AbYEIQ6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762165AbYEIQ6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:58:42 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:23015 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106AbYEIQ6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:58:40 -0400
Date: Fri, 9 May 2008 18:58:31 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: trenn@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: linux-next: ACPI I/O resource conflicts warning
Message-ID: <20080509185831.579e1a4e@hyperion.delvare>
In-Reply-To: <4824813B.6090607@googlemail.com>
References: <4823A6DA.8010502@googlemail.com>
	<1210343425.29724.39.camel@queen.suse.de>
	<4824813B.6090607@googlemail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 May 2008 18:52:11 +0200, Gabriel C wrote:
> Thomas Renninger wrote:
> > On Fri, 2008-05-09 at 03:20 +0200, Gabriel C wrote:
> >> Hi all ,
> >>
> >> I've noticed on linux-next from today the following ACPI warning:
> >>
> >> ...
> >>
> >> [4294023.308622] ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
> >> [4294023.308622] ACPI: I/O resource  [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
> >> [4294023.316478] ACPI: Device needs an ACPI driver
> > 
> > You use libsensors and the sensor you use is also declared and possibly
> > used via ACPI.
> 
> Not really , lsmsensors was not running and no modules loaded for my sensors but yeah when I start it another warning
> pops up ( this one I've reported to lm-sensors mailing list )

Could be your SMBus controller then, we have these checks in both hwmon
drivers and i2c bus drivers... Check what appears at 0x400
in /proc/iports.

> w83627ehf: Found W83627DHG chip at 0x290
> ACPI: I/O resource w83627ehf [0x295-0x296] conflicts with ACPI region HWRE [0x290-0x299]
> ACPI: Device needs an ACPI driver
> 
> > 
> >> dsdt.dsl from my motherboard can be found there:
> >>
> >> http://frugalware.org/~crazy/ASUS_P5E-VM_DO/dsdt.dsl
> >>
> >> full dmesg:
> >>
> >> http://frugalware.org/~crazy/dmesg/DMAR/dmesg
> >>
> >> Please let me know if you need more infos.
> > 
> > Maybe you could open a bug report on bugzilla.kernel.org and post
> > acpidump and dmi output (not only dsdt) there. Then we could collect
> > affected BIOSes at one central place for further evaluation and
> > discussion.
> 
> Sure I will open an task about soon.

When you do, please add me to Cc, thanks.

-- 
Jean Delvare
