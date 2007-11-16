Return-Path: <linux-kernel-owner+w=401wt.eu-S1763717AbXKPLVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763717AbXKPLVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 06:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbXKPLVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 06:21:04 -0500
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:49567 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbXKPLVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 06:21:02 -0500
Date: Fri, 16 Nov 2007 11:20:51 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Oliver Neukum <oliver@neukum.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: question on odd APIC behavior
In-Reply-To: <200711161203.29142.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64N.0711161112440.25869@blysk.ds.pg.gda.pl>
References: <200711150054.34312.oliver@neukum.org> <200711151905.03005.oliver@neukum.org>
 <Pine.LNX.4.64N.0711160959010.25869@blysk.ds.pg.gda.pl>
 <200711161203.29142.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007, Oliver Neukum wrote:

> > > On irq 20, there's an UHCI, on irq 19 is an EHCI. For every interrupt on 20
> > > there's a spurious interrupt on 19. USB devices on bus of the controller on 20
> > > work. So I know all interrupts are seen. ERR does not increase. Interrupts
> > > for devices on the bus of the controller on 19 arrive at 19 only.
> > 
> >  I suggest you try to sort it out with the maintainers of the UHCI and 
> > EHCI drivers then.
> 
> They are innocent. This laptop really delivers an interrupt twice.

 Perhaps, but these drivers are involved and the device-specific knowledge 
will help tracking down the cause.  I have general experience on how 
interrupts work, including on APIC-based systems, but I have no idea how 
UHCI and EHCI devices work in this area and, in particular, how you know 
an interrupt coming from the line #19 is related to one on the line #20 
and then a spurious one if not recorded as ERR or otherwise unclaimed 
(which would be reported as "irq 19: nobody cared").

  Maciej
