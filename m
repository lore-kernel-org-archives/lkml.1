Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbZI1UPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbZI1UPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZI1UPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:15:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38389 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZI1UPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:15:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 1/2] PM / PCMCIA: Drop second argument of pcmcia_socket_dev_suspend()
Date: Mon, 28 Sep 2009 22:16:53 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, linux-pcmcia@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Florian <fs-kernelbugzilla@spline.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200909260122.59030.rjw@sisk.pl> <200909260125.11149.rjw@sisk.pl> <20090928113112.GA5602@pengutronix.de>
In-Reply-To: <20090928113112.GA5602@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200909282216.53633.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 September 2009, Wolfram Sang wrote:
> On Sat, Sep 26, 2009 at 01:25:11AM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > pcmcia_socket_dev_suspend() doesn't use its second argument, so it
> > may be dropped safely.
> > 
> > This change is necessary for the subsequent yenta suspend/resume fix.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/pcmcia/at91_cf.c        |    2 +-
> >  drivers/pcmcia/au1000_generic.c |    2 +-
> >  drivers/pcmcia/bfin_cf_pcmcia.c |    2 +-
> >  drivers/pcmcia/cs.c             |    2 +-
> >  drivers/pcmcia/i82092.c         |    2 +-
> >  drivers/pcmcia/i82365.c         |    2 +-
> >  drivers/pcmcia/m32r_cfc.c       |    2 +-
> >  drivers/pcmcia/m32r_pcc.c       |    2 +-
> >  drivers/pcmcia/m8xx_pcmcia.c    |    2 +-
> >  drivers/pcmcia/omap_cf.c        |    2 +-
> >  drivers/pcmcia/pd6729.c         |    2 +-
> >  drivers/pcmcia/pxa2xx_base.c    |    2 +-
> >  drivers/pcmcia/sa1100_generic.c |    2 +-
> >  drivers/pcmcia/sa1111_generic.c |    2 +-
> >  drivers/pcmcia/tcic.c           |    2 +-
> >  drivers/pcmcia/vrc4171_card.c   |    2 +-
> >  include/pcmcia/ss.h             |    2 +-
> 
> Hmm, you are not converting yenta_socket here. Won't that break building the
> kernel (git bisect)?

You're right, I should have modified yenta_socket.c here as well.  Will fix.

Thanks,
Rafael
