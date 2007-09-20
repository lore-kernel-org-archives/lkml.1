Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbXITHd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbXITHd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbXITHds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:33:48 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:24403 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbXITHdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:33:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DMJ3TqlOYqYRipQKGai55tflUlIta2lDcRGzALfcey69gJzpyLp4DS2Pm0oVy4+MGfGZ9dTANyydMj2SqDq7HiUwAvutn/faXmjn2NUnEw/v8nik28P7gFMq+UHJZZVw2Zc3w+PrwON6h96Q6R9p34FspisnqMmPUofnDvaRofI=
Message-ID: <21d7e9970709200033k3f0f46feq7dae4e0a106f0372@mail.gmail.com>
Date: Thu, 20 Sep 2007 17:33:45 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, zhenyu.z.wang@intel.com
In-Reply-To: <46F22048.8050401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com>
	 <20070919121017.0cbcbc30.akpm@linux-foundation.org>
	 <20070919192453.GB18707@one.firstfloor.org>
	 <46F17CA1.5080205@gmail.com>
	 <20070919195425.GF18707@one.firstfloor.org>
	 <46F17F27.5080000@gmail.com>
	 <21d7e9970709191851s1b3f35c1j42faae3ce6cd0b24@mail.gmail.com>
	 <46F22048.8050401@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Fatal server error:
> >> Couldn't bind memory for front buffer
> >>
> >> I thought I'd seen a thread about this issue, but I can't find it now. Is it
> >> known or am I seeing ghosts yet, Andrew?
> >>
> >
> > Can you send me a complete Xorg log file?
>
> Maybe you are rather interested in these dmesg lines:
> Linux agpgart interface v0.102
> agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
> on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
> agpgart: Detected an Intel G33 Chipset.
> agpgart: Detected 8192K stolen memory.
> agpgart: AGP aperture is 256M @ 0xd0000000
> [drm] Initialized drm 1.1.0 20060810
> ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
> [drm] Initialized i915 1.6.0 20060119 on minor 0
> ...
> set status page addr 0x00033000
> agpgart: pg_start == 0x000005ff,intel_private.gtt_entries == 0x00000800
> agpgart: Trying to insert into local/stolen memory
>
> So the problem is, that X passes too low start.
>
> The X log:
> http://www.fi.muni.cz/~xslaby/sklad/Xorg.0.log.old
>

I've cc'd Zhenyu who might be able to shed some light on this? can you
try 2.6.23-rc7 as maybe the G33 support still needs some work.. or
maybe I'm missing a patch in the drm..

Dave.
