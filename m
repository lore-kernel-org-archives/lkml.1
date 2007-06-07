Return-Path: <linux-kernel-owner+w=401wt.eu-S1764616AbXFGPo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764616AbXFGPo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762198AbXFGPoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:44:20 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:34089 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758726AbXFGPoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:44:19 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Thu, 7 Jun 2007 09:44:07 -0600
User-Agent: KMail/1.9.6
Cc: "Samuel Ortiz" <samuel@sortiz.org>, arvidjaar@mail.ru,
       linux-kernel@vger.kernel.org,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706051723.56436.bjorn.helgaas@hp.com> <A6D19A13FE030A409EC4362C172E091F016F51BC@eseldmw101.eemea.ericsson.se>
In-Reply-To: <A6D19A13FE030A409EC4362C172E091F016F51BC@eseldmw101.eemea.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200706070944.07674.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2007 06:23:58 am Linus Walleij (LD/EAB) wrote:
> Björn wrote:
> > Something's wrong with this strategy.  The BIOS is telling us 
> > that an SMCf010 device is present, active, and responds at io 
> > ports 0x100-0x107 and 0x2e8-0x2ef.  The fact that it happens 
> > to be on the other side of an ISA or LPC bridge should be 
> > immaterial to the OS driver.
> 
> Yes, ideally. Yes of course it is wrong, or from a platonic
> perspective. If nobody wrote buggy BIOS:es there would be no
> problem.

Yup, I agree that we will always need to work around BIOS bugs.

But smsc-ircc2 contains a *lot* of preconfigure stuff.  I'm
skeptical that all of it is really to work around BIOS bugs.
I think it's more likely that Linux just isn't using the PNP
info correctly or drivers for other southbridge devices are
getting in the way.

> There is some history in the preconfigure functions:
> these come from the smcinit tool (see http://irda.sourceforge.net/smcinit/),

Thanks for the pointer.  I'll read over that and see if I can
find a laptop to play with.

Bjorn

