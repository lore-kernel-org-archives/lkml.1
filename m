Return-Path: <linux-kernel-owner+w=401wt.eu-S1765054AbXKPLDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765054AbXKPLDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 06:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbXKPLDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 06:03:36 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:36292 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718AbXKPLDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 06:03:35 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: question on odd APIC behavior
Date: Fri, 16 Nov 2007 12:03:28 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <200711150054.34312.oliver@neukum.org> <200711151905.03005.oliver@neukum.org> <Pine.LNX.4.64N.0711160959010.25869@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0711160959010.25869@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711161203.29142.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 16 November 2007 schrieb Maciej W. Rozycki:
> On Thu, 15 Nov 2007, Oliver Neukum wrote:
> 
> > On irq 20, there's an UHCI, on irq 19 is an EHCI. For every interrupt on 20
> > there's a spurious interrupt on 19. USB devices on bus of the controller on 20
> > work. So I know all interrupts are seen. ERR does not increase. Interrupts
> > for devices on the bus of the controller on 19 arrive at 19 only.
> 
>  I suggest you try to sort it out with the maintainers of the UHCI and 
> EHCI drivers then.

They are innocent. This laptop really delivers an interrupt twice.

	Regards
		Oliver
