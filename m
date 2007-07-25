Return-Path: <linux-kernel-owner+w=401wt.eu-S932586AbXGYAzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbXGYAzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 20:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbXGYAzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 20:55:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:60648 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354AbXGYAzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 20:55:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FyjaxTUM0D6GLw/4/jFda7b5tC4vfOOUbayxZq4e2RTeWmsuCTDyNCn6NRvS0ErrXhknnWGMOaJgl2PJOVNLmVj1PoQqqP9ANXb8VsW2RUesp4uXc9fqY3OVsSuHJIfbc82tjGteKfZxJeg+qv0MPgR/raB2eU9DhKDkQCDPTqM=
Message-ID: <86802c440707241755u44f9d86bg1daf7b20e80fc531@mail.gmail.com>
Date: Tue, 24 Jul 2007 17:55:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: Patches for REALLY TINY 386 kernels
Cc: "Helge Hafting" <helge.hafting@aitel.hist.no>,
       "Andi Kleen" <andi@firstfloor.org>, "Uwe Hermann" <uwe@hermann-uwe.de>,
       "Matt Mackall" <mpm@selenic.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Jonathan Campbell" <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070724225633.GA5444@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469A8AED.7070207@nerdgrounds.com> <469E3806.4030804@zytor.com>
	 <20070718194137.GG11166@waste.org>
	 <20070718201043.GF3898@one.firstfloor.org>
	 <20070718204102.GM11115@waste.org> <20070720072730.GN3700@greenwood>
	 <20070720073509.GA19833@one.firstfloor.org>
	 <46A61163.3000701@aitel.hist.no>
	 <86802c440707241350o4e5d2d24w654c935fb2972b54@mail.gmail.com>
	 <20070724225633.GA5444@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Tue, Jul 24, 2007 at 01:50:35PM -0700, Yinghai Lu wrote:
> > On 7/24/07, Helge Hafting <helge.hafting@aitel.hist.no> wrote:
> >> Andi Kleen wrote:
> >> >> Some people are putting Linux kernels in the "BIOS" (i.e. ROM chip)
> >> when
> >> >> using LinuxBIOS (www.linuxbios.org). It _does_ make a lot of difference
> >> >> there how big the kernel is. At the moment you can't do that with
> >> >> anything smaller than a 1 MB chip. But if people could use 512 KB chips
> >> >> because the kernel is small enough that would sure be a great thing.
> >> >>
> >> >
> >> > I'm sure it would be possibel to save a lot of text size. But I don't
> >> > think removing the relatively small CPUID code is the right way.
> >> > That is just a big maintenance issue for little gain.
> >> >
> >> Well - anyone compiling linux for BIOS usage is targetting
> >> a single machine.  So an ability to target a single machine is useful,
> >> i.e. run the CPUID at compile-time, put the answer in a constant/macro,
> >> let the optimizer prune the alternatives. :-)
> >
> > we are using AMD64 + LinuxBIOS + Kernel (without acpi) + kexec to load
> > final kernel.
> > So we can use drivers in kernel for any media (SCSI, SATA, IB,...),
> > not like EFI need every driver re-porting. and We could use KVM in
> > kernel to load other OS if needed.
> >
> > The problem is Kernel is getting bigger and bigger. and old Tiny
> > kernel is stopping at 2.6.18...
> >...
>
> Please send:
> - the .config for the last kernel small enough
> - your size limit
> - your gcc version
> and I'll look at this.

http://www.linuxbios.org/Tyan_S2892_Build_Tutorial
http://www.linuxbios.org/pipermail/linuxbios/2006-October/016558.html

YH
