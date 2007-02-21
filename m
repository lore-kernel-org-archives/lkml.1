Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbXBUXzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbXBUXzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbXBUXzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:55:38 -0500
Received: from mcr-smtp-002.bulldogdsl.com ([212.158.248.8]:4422 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932506AbXBUXzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:55:37 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
Date: Wed, 21 Feb 2007 23:55:25 +0000
User-Agent: KMail/1.9.5
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Udo van den Heuvel <udovdh@xs4all.nl>,
       linux-kernel@vger.kernel.org
References: <45D85DA1.7090502@xs4all.nl> <m3hctfqjna.fsf@maximus.localdomain> <20070221224027.GK22464@csclub.uwaterloo.ca>
In-Reply-To: <20070221224027.GK22464@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702212355.25601.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 February 2007 22:40, Lennart Sorensen wrote:
> On Wed, Feb 21, 2007 at 10:35:05PM +0100, Krzysztof Halasa wrote:
> > Do you mean both slots on the riser card? No, they have to be rotated.
> >
> > Given the table from the manual:
> > > The IRQ (interrupt request line) are hardware lines over which devices
> > > can send interrupt signals to the microprocessor. The ??PCI & LAN?? IRQ
> > > pins are typically connected to the PCI bus INT A# ~ INT D# pins as
> > > follows: Order 1		Order 2 	Order 3 	Order 4
> > > PCI Slot 1	INT B# 		INT C# 		INT D# 		INT A#
> > > IEEE1394 	INT B#
> >
> > (I assume Order 1 is device's INT A and so on)
> > the chipset-centric view is:
>
> Well someone said the VIA uses INTA for the DN19 on their riser card,
> although is that INTA from the CPUs point of view or INTA from the slot
> the riser card is plugged into?  There was also mention of a BIOS update
> needed on some boards to even support the riser card at all.  Maybe that
> applies.

It applies on the M10000, I'm sure the newer EN series boards have always 
supported the feature.

One warning to you though, I found the riser to be pretty flaky, causing 
bizarre lockups and periodic crashes of Linux. Maybe this is a Linux bug, but 
it really didn't seem like it.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
