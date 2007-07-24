Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbXGXW5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbXGXW5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbXGXW5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:57:08 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43473 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751881AbXGXW5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:57:06 -0400
Date: Wed, 25 Jul 2007 00:56:33 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>,
       Andi Kleen <andi@firstfloor.org>, Uwe Hermann <uwe@hermann-uwe.de>,
       Matt Mackall <mpm@selenic.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070724225633.GA5444@stusta.de>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718194137.GG11166@waste.org> <20070718201043.GF3898@one.firstfloor.org> <20070718204102.GM11115@waste.org> <20070720072730.GN3700@greenwood> <20070720073509.GA19833@one.firstfloor.org> <46A61163.3000701@aitel.hist.no> <86802c440707241350o4e5d2d24w654c935fb2972b54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <86802c440707241350o4e5d2d24w654c935fb2972b54@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 01:50:35PM -0700, Yinghai Lu wrote:
> On 7/24/07, Helge Hafting <helge.hafting@aitel.hist.no> wrote:
>> Andi Kleen wrote:
>> >> Some people are putting Linux kernels in the "BIOS" (i.e. ROM chip) 
>> when
>> >> using LinuxBIOS (www.linuxbios.org). It _does_ make a lot of difference
>> >> there how big the kernel is. At the moment you can't do that with
>> >> anything smaller than a 1 MB chip. But if people could use 512 KB chips
>> >> because the kernel is small enough that would sure be a great thing.
>> >>
>> >
>> > I'm sure it would be possibel to save a lot of text size. But I don't
>> > think removing the relatively small CPUID code is the right way.
>> > That is just a big maintenance issue for little gain.
>> >
>> Well - anyone compiling linux for BIOS usage is targetting
>> a single machine.  So an ability to target a single machine is useful,
>> i.e. run the CPUID at compile-time, put the answer in a constant/macro,
>> let the optimizer prune the alternatives. :-)
>
> we are using AMD64 + LinuxBIOS + Kernel (without acpi) + kexec to load
> final kernel.
> So we can use drivers in kernel for any media (SCSI, SATA, IB,...),
> not like EFI need every driver re-porting. and We could use KVM in
> kernel to load other OS if needed.
>
> The problem is Kernel is getting bigger and bigger. and old Tiny
> kernel is stopping at 2.6.18...
>...

Please send:
- the .config for the last kernel small enough
- your size limit
- your gcc version
and I'll look at this.

> YH

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

