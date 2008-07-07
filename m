Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbYGGMWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbYGGMWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbYGGMWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:22:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60394 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbYGGMWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:22:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Date: Mon, 7 Jul 2008 14:24:26 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <20080707071706.GA3326@elte.hu> <20080707073635.GA22946@elte.hu>
In-Reply-To: <20080707073635.GA22946@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807071424.27967.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of July 2008, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Please note two things:
> > > (1) The whole acpi_dmi_table[] thing originally depended on __i386__, so it
> > >     wouldn't work on x86-64 no matter what.  I removed that dependecy, but
> > >     I have no idea why it was there and so I'm not sure if that's correct. 
> > 
> > > (2) The clear_IO_APIC_pin(apic1, pin1) done if 
> > >     disable_irq0_through_ioapic is true is absolutely essential.  The 
> > >     symptoms are 100% reproducible without it.
> > 
> > thanks, applied to tip/x86, to give this some more testing.
> 
> i know you havent submitted this for inclusion yet, but FYI it wont 
> build on 32-bit with a config like:
> 
>  http://redhat.com/~mingo/misc/config-Mon_Jul__7_09_22_45_CEST_2008.bad

Well, I wrote it was missing the i386 part. ;-)

Thanks,
Rafael
