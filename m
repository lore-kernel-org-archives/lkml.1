Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbZLDUan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbZLDUan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbZLDUal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:30:41 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33024 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbZLDUak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:30:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:x-url:user-agent;
        b=uebGLKcNn7Dr/G6ebzfG1toDQPqZfy/UvtRFVTLvbbAMPMT5OAm3einXGnmYHMYDxX
         zqeO65YQkhA7GqK53Se9hS1KI/V5EYVzlkFfPKZ5V+cbhLFmu/rMOWUiOrEw48vHArJp
         ejqfVOXZRgIDjZpl0ZVmaDzkhBxvc/pyqLAo4=
Date: Fri, 4 Dec 2009 22:30:43 +0200
From: Amit Kucheria <amit.kucheria@canonical.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com
Subject: Re: [RFC][PATCH 01/10] arm: mxc: New interrupt controller (TZIC)
 for i.MX5 family
Message-ID: <20091204203043.GF3747@matterhorn.verdurent.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	List Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
	valentin.longchamp@epfl.ch, daniel@caiaq.de,
	grant.likely@secretlab.ca, Dinh.Nguyen@freescale.com,
	r.herring@freescale.com
References: <cover.1259893118.git.amit.kucheria@canonical.com>
 <e99e70e2a619693064130a747b6ee3a93273337b.1259893118.git.amit.kucheria@canonical.com>
 <20091204090139.ff60024c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091204090139.ff60024c.randy.dunlap@oracle.com>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 Dec 04, Randy Dunlap wrote:
> On Fri,  4 Dec 2009 04:47:01 +0200 Amit Kucheria wrote:
> 
> > Freescale i.MX51 processor uses a different interrupt controller. Add the
> > driver and fix the Makefile to account for it.
> > 
> > Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> > ---
> >  arch/arm/plat-mxc/Kconfig  |    4 +
> >  arch/arm/plat-mxc/Makefile |    9 ++-
> >  arch/arm/plat-mxc/tzic.c   |  180 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 192 insertions(+), 1 deletions(-)
> >  create mode 100644 arch/arm/plat-mxc/tzic.c
> > 
> > diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
> > new file mode 100644
> > index 0000000..3af8fc6
> > --- /dev/null
> > +++ b/arch/arm/plat-mxc/tzic.c
> > @@ -0,0 +1,180 @@
> > +/*
> > + * Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> > + *
> > + * The code contained herein is licensed under the GNU General Public
> > + * License. You may obtain a copy of the GNU General Public License
> > + * Version 2 or later at the following locations:
> > + *
> > + * http://www.opensource.org/licenses/gpl-license.html
> > + * http://www.gnu.org/copyleft/gpl.html
> > + */
> > +
> ...
> > +
> > +/*!
> > + * Disable interrupt number "irq" in the TZIC
> > + *
> > + * @param  irq          interrupt source number
> > + */
> 
> Hi,
> What processes these function comments (if anything does)?
> 

I'm afraid I can't help you there. It is probably an internal documentation standard inside Freescale. I'll get rid of the rest in the next submission.

Regards,
Amit

-- 
------------------------------------------------------------
Amit Kucheria, Finland
------------------------------------------------------------
