Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbXDOVqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbXDOVqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 17:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXDOVqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 17:46:20 -0400
Received: from smtp.bulldogdsl.com ([212.158.248.8]:4592 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989AbXDOVps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 17:45:48 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Mikko Tiihonen <mikko.tiihonen@iki.fi>
Subject: Re: [PATCH] hpet: Enable hidden HPET on NVidia motherboards
Date: Sun, 15 Apr 2007 22:45:41 +0100
User-Agent: KMail/1.9.5
Cc: clemens@ladisch.de, bob.picco@hp.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.OSF.4.64.0704152218330.487506@kosh.hut.fi>
In-Reply-To: <Pine.OSF.4.64.0704152218330.487506@kosh.hut.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704152245.42026.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007 21:14, Mikko Tiihonen wrote:
> Enables HPET for NVidia motherboards with broken BIOS. The patch reads the
> HPET address from the pci config space. The patch should also work if ACPI
> is disabled.
>
> The HPET search is done in early-quirks because even
> DECLARE_PCI_FIXUP_EARLY was too late. If the new quirk causes problems it
> can be disabled with the nohpet boot option.
>
> The patch assumes that the BIOS has done the basic setup of HPET, but has
> not published the result in ACPI tables. This is at least true for some
> Asus and Gigabyte motherboards.

This works fine on my DFI Lanparty UT nForce4 CK804 mainboard:

alistair@damocles:~$ dmesg | grep hpet
[   25.677099] hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
[   25.677102] hpet0: 3 32-bit timers, 25000000 Hz
[   25.678799] Time: hpet clocksource has been installed.

I've been wanting hpets for a while, this patch is extremely useful to me.

Unfortunately your patch does not seem to apply with standard tools, perhaps 
your mailer corrupted it (I just hand applied it).

Thanks Mikko.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
