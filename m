Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbXFOPTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbXFOPTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXFOPT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:19:26 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:46161 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbXFOPT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:19:26 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Fri, 15 Jun 2007 09:19:13 -0600
User-Agent: KMail/1.9.6
Cc: Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706141530.56176.bjorn.helgaas@hp.com> <200706151744.42366.arvidjaar@mail.ru>
In-Reply-To: <200706151744.42366.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150919.14150.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 07:44:41 am Andrey Borzenkov wrote:
> On Friday 15 June 2007, Bjorn Helgaas wrote:
> > Hi Andrey,
> >
> > If you have a chance, can you try the attached two patches?  The
> > smsc-preconfig patch makes the HP nx5000 work, and the smsc-quirk
> > patch makes the nw8000/nc8000 work, too.
> >
> > I've heard rumors that Windows does basically the same thing as the
> > smsc-quirk patch, so I think there's a chance it might make your
> > Toshiba work as well.
> >
> > I sent the smsc-preconfig patch to Andrew this morning.  I'm going
> > to do some more testing other HP laptops before sending him the
> > smsc-quirk patch.
> >
> 
> Does not work, sorry. (Patches were taken from your another mails but I assume 
> they are the same). Does not work even if I unload PCMCIA/yenta_socket 
> to "free" resources.
> 
> I am out of ideas but am ready to test patches if someone has.

Thanks for testing that.  I bought a Portege 4000 so I can work
on this without bothering you.  I'll let you know if I make any
progress on it.

Bjorn



