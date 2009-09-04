Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbZIDTsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbZIDTsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757293AbZIDTsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:48:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37526 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198AbZIDTsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:48:06 -0400
From: "Madhusudhan" <madhu.cr@ti.com>
To: "'Tony Lindgren'" <tony@atomide.com>,
       "'Pandita, Vikram'" <vikram.pandita@ti.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Kadiyala, Kishore'" <kishore.kadiyala@ti.com>,
       <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
References: <34590.192.168.10.89.1251897876.squirrel@dbdmail.itg.ti.com> <20090904121912.4b4e2b5a.akpm@linux-foundation.org> <FCCFB4CDC6E5564B9182F639FC35608702F9B8A526@dbde02.ent.ti.com> <20090904193347.GD15715@atomide.com>
Subject: RE: [PATCH] OMAP4: MMC driver support on OMAP4
Date: Fri, 4 Sep 2009 14:47:18 -0500
Message-ID: <00dc01ca2d98$832f6240$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20090904193347.GD15715@atomide.com>
Thread-Index: Acotlqy+GYzOH9TaTmKjQckv1IpMmAAAZdgA
x-mimeole: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Tony Lindgren [mailto:tony@atomide.com]
> Sent: Friday, September 04, 2009 2:34 PM
> To: Pandita, Vikram
> Cc: Andrew Morton; Kadiyala, Kishore; linux-kernel@vger.kernel.org; linux-
> omap@vger.kernel.org; jarkko.lavinen@nokia.com; Chikkature Rajashekar,
> Madhusudhan; linux-arm-kernel@lists.arm.linux.org.uk; linux-arm-
> kernel@lists.infradead.org; linux-mmc@vger.kernel.org
> Subject: Re: [PATCH] OMAP4: MMC driver support on OMAP4
> 
> * Pandita, Vikram <vikram.pandita@ti.com> [090904 12:24]:
> > Andrew/Kishore
> >
> > >-----Original Message-----
> > >From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Andrew
> > >Morton
> > >Sent: Friday, September 04, 2009 2:19 PM
> > >
> > >On Wed, 2 Sep 2009 18:54:36 +0530 (IST)
> > >"kishore kadiyala" <kishore.kadiyala@ti.com> wrote:
> > >
> > >> This Patch adds basic support for all 5 MMC controllers on OMAP4.
> > >>
> > >> -Kishore
> > >>
> > >> Signed-off-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
> > >> ---
> > >> This patch doesn't include mmc-regulator support
> > >>
> > >
> > >This looks like an ARM patch more than an MMC patch.  I grabbed it as
> > >an MMC thing but hopefully someone else will grab it for a more
> > >appropriate tree.
> >
> > A patch split is required:
> >
> > >>  arch/arm/mach-omap2/devices.c          |   42
> +++++++++++++++++++++++++++++----
> > >>  arch/arm/plat-omap/include/mach/irqs.h |    2 +
> > >>  arch/arm/plat-omap/include/mach/mmc.h  |    9 ++++++-
> >
> > These files will go through linux-omap -> arm: to RMK
> >
> > >>  drivers/mmc/host/Kconfig               |    6 ++--
> > >>  drivers/mmc/host/omap_hsmmc.c          |   10 +++++++
> > >>  5 files changed, 60 insertions(+), 9 deletions(-)
> >
> > These files can go through Andrew.
> 
> No need to split it IMHO, it's best to merge it all together
> via Andrew's MMC queue as it should not conflict with other
> arch/arm/*omap* stuff.
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

Request to add my ACK.

Acked-by: Madhusudhan Chikkature <madhu.cr@ti.com>


