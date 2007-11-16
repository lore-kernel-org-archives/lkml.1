Return-Path: <linux-kernel-owner+w=401wt.eu-S934882AbXKPVfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882AbXKPVfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759416AbXKPVfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:35:01 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:55251 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962AbXKPVfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:35:00 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: question on odd APIC behavior
Date: Fri, 16 Nov 2007 22:34:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <200711150054.34312.oliver@neukum.org> <200711161203.29142.oliver@neukum.org> <Pine.LNX.4.64N.0711161112440.25869@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0711161112440.25869@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711162234.54268.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 16 November 2007 schrieb Maciej W. Rozycki:
> On Fri, 16 Nov 2007, Oliver Neukum wrote:
> 
> > > > On irq 20, there's an UHCI, on irq 19 is an EHCI. For every interrupt on 20
> > > > there's a spurious interrupt on 19. USB devices on bus of the controller on 20
> > > > work. So I know all interrupts are seen. ERR does not increase. Interrupts
> > > > for devices on the bus of the controller on 19 arrive at 19 only.
> > > 
> > >  I suggest you try to sort it out with the maintainers of the UHCI and 
> > > EHCI drivers then.
> > 
> > They are innocent. This laptop really delivers an interrupt twice.
> 
>  Perhaps, but these drivers are involved and the device-specific knowledge 
> will help tracking down the cause.  I have general experience on how 
> interrupts work, including on APIC-based systems, but I have no idea how 
> UHCI and EHCI devices work in this area and, in particular, how you know 
> an interrupt coming from the line #19 is related to one on the line #20 
> and then a spurious one if not recorded as ERR or otherwise unclaimed 
> (which would be reported as "irq 19: nobody cared").

I am getting irq 19:nobody cared. Interrupts on 19 and 20 increase with
same rate, disconnecting the device on the bus stops the increase,
reconnecting it makes them increase again.

	Regards
		Oliver
