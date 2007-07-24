Return-Path: <linux-kernel-owner+w=401wt.eu-S932540AbXGXUur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540AbXGXUur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbXGXUui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:50:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:15624 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbXGXUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HAKvkQbw7lS967eHrhCGvxsgUOvw4Vye2wyMB4L1rX65eSVg3xrlCBJmakzCKhPaNgXsBnoBFhZ2Kz9ydXk8OMYZaefWiUoRUBOFY4PduGDmCgBAlHUGXemtziusBug4RwGyTmQOsqLztE7KHF5XoQDRJ1tluwR4pvd11/XThKQ=
Message-ID: <86802c440707241350o4e5d2d24w654c935fb2972b54@mail.gmail.com>
Date: Tue, 24 Jul 2007 13:50:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Subject: Re: Patches for REALLY TINY 386 kernels
Cc: "Andi Kleen" <andi@firstfloor.org>, "Uwe Hermann" <uwe@hermann-uwe.de>,
       "Matt Mackall" <mpm@selenic.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Jonathan Campbell" <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
In-Reply-To: <46A61163.3000701@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de>
	 <469E3806.4030804@zytor.com> <20070718194137.GG11166@waste.org>
	 <20070718201043.GF3898@one.firstfloor.org>
	 <20070718204102.GM11115@waste.org> <20070720072730.GN3700@greenwood>
	 <20070720073509.GA19833@one.firstfloor.org>
	 <46A61163.3000701@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Helge Hafting <helge.hafting@aitel.hist.no> wrote:
> Andi Kleen wrote:
> >> Some people are putting Linux kernels in the "BIOS" (i.e. ROM chip) when
> >> using LinuxBIOS (www.linuxbios.org). It _does_ make a lot of difference
> >> there how big the kernel is. At the moment you can't do that with
> >> anything smaller than a 1 MB chip. But if people could use 512 KB chips
> >> because the kernel is small enough that would sure be a great thing.
> >>
> >
> > I'm sure it would be possibel to save a lot of text size. But I don't
> > think removing the relatively small CPUID code is the right way.
> > That is just a big maintenance issue for little gain.
> >
> Well - anyone compiling linux for BIOS usage is targetting
> a single machine.  So an ability to target a single machine is useful,
> i.e. run the CPUID at compile-time, put the answer in a constant/macro,
> let the optimizer prune the alternatives. :-)

we are using AMD64 + LinuxBIOS + Kernel (without acpi) + kexec to load
final kernel.
So we can use drivers in kernel for any media (SCSI, SATA, IB,...),
not like EFI need every driver re-porting. and We could use KVM in
kernel to load other OS if needed.

The problem is Kernel is getting bigger and bigger. and old Tiny
kernel is stopping at 2.6.18...

add CONFIG_TINY_KERNEL in the kernel to remove unnessceary workaround
and quirks...

YH
