Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbYDRBNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbYDRBNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 21:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbYDRBN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 21:13:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756621AbYDRBNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 21:13:14 -0400
Date: Thu, 17 Apr 2008 18:12:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, penberg@cs.helsinki.fi,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jmorris@namei.org, sds@tycho.nsa.gov
Subject: Re: 2.6.25-mm1: not looking good
Message-Id: <20080417181230.334d087a.akpm@linux-foundation.org>
In-Reply-To: <3ae72650804171748y713c965bvbaf5de39e05ab555@mail.gmail.com>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
	<20080417232441.GA19281@kroah.com>
	<3ae72650804171748y713c965bvbaf5de39e05ab555@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 02:48:19 +0200
"Kay Sievers" <kay.sievers@vrfy.org> wrote:

> On Fri, Apr 18, 2008 at 1:24 AM, Greg KH <greg@kroah.com> wrote:
> >
> > On Thu, Apr 17, 2008 at 04:03:31PM -0700, Andrew Morton wrote:
> >  >
> >  > I repulled all the trees an hour or two ago, installed everything on an
> >  > 8-way x86_64 box and:
> 
> >  > usb/sysfs:
> >  >
> >  > ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 17 (level, low) -> IRQ 17
> >  > uhci_hcd 0000:00:1d.0: UHCI Host Controller
> >  > uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
> >  > uhci_hcd 0000:00:1d.0: irq 17, io base 0x00002080
> >  > usb usb1: configuration #1 chosen from 1 choice
> >  > hub 1-0:1.0: USB hub found
> >  > hub 1-0:1.0: 2 ports detected
> >  > sysfs: duplicate filename '189:0' can not be created
> >
> >  Interesting, that's the new major:minor code.  I'll go poke at it...
> 
> Is this with the deprecated CONFIG_USB_DEVICE_CLASS=y?

Yes.

> They have the
> same dev_t as usb_device and would be a reason for the duplicates.
> 
