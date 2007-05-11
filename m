Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbXEKNiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbXEKNiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 09:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbXEKNhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 09:37:53 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:57993 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXEKNhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 09:37:52 -0400
Message-ID: <1178890671.464471af1bd04@imp.free.fr>
Date: Fri, 11 May 2007 15:37:51 +0200
From: Remi Colinet <remi.colinet@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Regression in 2.6.21-mm1 (git-input) on Dell D610 laptop
References: <1178802325.46431895e9469@imp.free.fr> <20070510185021.c3d28048.akpm@linux-foundation.org>
In-Reply-To: <20070510185021.c3d28048.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 81.255.27.251
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Selon Andrew Morton <akpm@linux-foundation.org>:

> On Thu, 10 May 2007 15:05:25 +0200
> Remi Colinet <remi.colinet@free.fr> wrote:
>
> > My D610 ALPS Glide Point is unresponsive with 2.6.21-mm1 patch.
> > No problem noticed with 2.6.21.
> >
> > The culprit seems to be git-input. I have applied 2.6.21-mm1 on top of
> 2.6.21
> > and then removed git-input patch. It is ok since then.
> >
> > >From what i can see, no interrupt is raised from the GlidePoint with
> git-input
> > applied. IRQ count 12 does not increase. It is when using the touchpad.
> >
> >            CPU0
> >   0:        160   IO-APIC-edge      timer
> >   1:        935   IO-APIC-edge      i8042
> >   7:          0   IO-APIC-edge      parport0
> >   8:          1   IO-APIC-edge      rtc
> >   9:          2   IO-APIC-fasteoi   acpi
> > => 12:        114   IO-APIC-edge      i8042 <=
> >  14:       3223   IO-APIC-edge      libata
> >  15:          5   IO-APIC-edge      libata
> >  16:          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5, Intel
> ICH6
> >  17:          1   IO-APIC-fasteoi   uhci_hcd:usb2, ipw2200, Intel ICH6
> Modem
> >  18:          0   IO-APIC-fasteoi   uhci_hcd:usb3
> >  19:          1   IO-APIC-fasteoi   uhci_hcd:usb4, yenta
> > NMI:          0
> > LOC:       4051
> > ERR:          0
> > MIS:          0
> >
> > I have also tried to disable the ALPS driver in the .config file. IRQ 12
> are
> > then raised when using the Glide Point. X refuses to start.
> >
>
> Are you able to test 2.6.21-mm2?
>
>

I have tried with the lastest mm broken-out snapshot, i.e 2.6.21-mm3.
The GlidePoint is still unresponsive.

2.6.21-git13 works fine with the GlidePoint.

So I'am bisecting 2.6.21-mm3. It works just with the origin.patch applied.

Thanks,
Remi Colinet






