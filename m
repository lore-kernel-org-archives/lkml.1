Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbXDUEbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbXDUEbE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 00:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbXDUEbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 00:31:03 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:16635 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbXDUEbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 00:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Cdw8O5qjhR/k3FpWSOz8BgCbiejjq/3nuKahifez8+9cH+5jHoHNlaPXUVIw3Sy/pZ7G3LIT6i+v6FFrOB2gTB3nYFj6NNAo6e0FSiOJlMOxrzZP77VjrmOQ+9Rc7A0xddXMMxSTvW+KLpJ+lOaYKogwn8oSVWktCRHi87lXfus=
Message-ID: <62eb359a0704202130p39cf24efu89dccc8437c30d25@mail.gmail.com>
Date: Fri, 20 Apr 2007 23:30:59 -0500
From: "Marcos Pinto" <markybob@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: 2.6.20.7 locking up hard on boot
Cc: linux-kernel@vger.kernel.org, "Jan Beulich" <jbeulich@novell.com>,
       "Alan Cox" <alan@redhat.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <20070421013454.GB4016@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <62eb359a0704201747ma376567kda671d6fa98b7409@mail.gmail.com>
	 <20070421013454.GB4016@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I just tried 2.6.20.3 with ACPI enabled and it booted perfectly.
I'm hoping this means you know what's wrong? :-)

Thanks again,
Marcos

On 4/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Fri, Apr 20, 2007 at 07:47:13PM -0500, Marcos Pinto wrote:
> > I'm not subscribed, so please personally CC me any answers/comments.
> > Thank you.
> >
> > While booting, (AMD64 Turion x2) 2.6.20.7 kernel locks up hard.  The
> > last kernel that I tried, 2.6.18.8, worked perfectly without any
> > trickery.  2.6.20.7 only boots up with "acpi=off" being added to the
> > kernel line.  Note that 2.6.18.8 works perfectly with acpi on, which
> > is really the
> > only way I can run this box because with "acpi=off" it overheats and
> > freezes.
> > Please let me know if there's anything else that I could do to help with
> > this.
> >
> >
> > Here's what's on the screen when it happens:
> >
> > Brought up 2 CPUs
> > testing NMI watchdog ... OK.
> > Disabling vsyscall due to  use of PM timer
> > time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
> > time.c: Detected 1808.264 MHz processor.
> > migration_cost=281
> > NET: Registered protocol family 16
> > ACPI: bus type pci registered
> > PCI: Using MMCONFIG at e0000000
> > PCI: No mmconfig possible on device 00:18
> > PCI: No mmconfig possible on device 07:05
> > ACPI: Interpreter enabled
> > ACPI: Using IOAPIC for interrupt routing
> > ACPI: PCI Root Bridge [PCI0] (0000:00)
> > ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
> > 0000:00:0d.0: cannot adjust BAR0 (not I/O)
> > 0000:00:0d.0: cannot adjust BAR1 (not I/O)
> >...
>
> Does 2.6.20.3 boot with ACPI enabled?
>
> cu
> Adrian
>
> --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
>
