Return-Path: <linux-kernel-owner+w=401wt.eu-S935360AbZDIRpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935360AbZDIRpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 13:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758534AbZDIRpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 13:45:17 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2576 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbZDIRpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:45:16 -0400
Subject: Re: [PATCH 02/10] MAINTAINERS - Add file patterns
From: Joe Perches <joe@perches.com>
To: Timur Tabi <timur@freescale.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <ed82fe3e0904090842l357c6ee9yab8a99a384ca4089@mail.gmail.com>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <1239167872-8179-3-git-send-email-joe@perches.com>
	 <ed82fe3e0904090842l357c6ee9yab8a99a384ca4089@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 10:42:08 -0700
Message-Id: <1239298928.29975.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 10:42 -0500, Timur Tabi wrote:
> On Wed, Apr 8, 2009 at 12:17 AM, Joe Perches <joe@perches.com> wrote:
> 
> >  CIRRUS LOGIC CS4270 SOUND DRIVER
> >  P:     Timur Tabi
> >  M:     timur@freescale.com
> >  L:     alsa-devel@alsa-project.org
> >  S:     Supported
> > +F:     sound/soc/codecs/cs4270*
> > +F:     sound/soc/fsl/mpc8610_hpcd.c
> 
> mpc8610_hpcd.c is not part of the CS4270 driver.  It's only cs4270*
> 
> >  FREESCALE SOC SOUND DRIVERS
> >  P:     Timur Tabi
> >  M:     timur@freescale.com
> >  L:     alsa-devel@alsa-project.org
> >  L:     linuxppc-dev@ozlabs.org
> >  S:     Supported
> > +F:     sound/soc/fsl/
> 
> This takes care of mpc8610_hpcd.c, but it also includes
> mpc5200_psc_i2s.c and soc-of-simple.c, which are not mine.

How about:

commit a781e5eab0dcb10e5b9b6665f6bb8baa196c11b5
Author: Joe Perches <joe@perches.com>
Date:   Thu Apr 9 10:39:22 2009 -0700

    MAINTAINERS - Update Freescale sound patterns
    
    Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 233895f..8fb51fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1359,13 +1359,12 @@ F:	drivers/usb/host/ohci-ep93xx.c
 CIRRUS LOGIC CS4270 SOUND DRIVER
 P:	Timur Tabi
 M:	timur@freescale.com
 L:	alsa-devel@alsa-project.org
 S:	Supported
 F:	sound/soc/codecs/cs4270*
-F:	sound/soc/fsl/mpc8610_hpcd.c
 
 CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
 P:	Cirrus Logic Corporation (kernel 2.2 driver)
 M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
 P:	Nils Faerber (port to kernel 2.4)
 M:	Nils Faerber <nils@kernelconcepts.de>
@@ -2247,13 +2246,14 @@ F:	drivers/serial/ucc_uart.c
 FREESCALE SOC SOUND DRIVERS
 P:	Timur Tabi
 M:	timur@freescale.com
 L:	alsa-devel@alsa-project.org
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
-F:	sound/soc/fsl/
+F:	sound/soc/fsl/fsl*
+F:	sound/soc/fsl/mpc8610_hpcd.c
 
 FREEVXFS FILESYSTEM
 P:	Christoph Hellwig
 M:	hch@infradead.org
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
 S:	Maintained


