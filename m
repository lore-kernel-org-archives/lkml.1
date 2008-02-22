Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbYBVWlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbYBVWlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbYBVWln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:41:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:40819 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680AbYBVWlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:41:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=E+t80IrMX9DtLCx4U12D5uUHbkf4U/O+6POS3x4y8wH4KKDR+SfqYwW0mmjWRL4JxlQjVVrYpRaXZ7geJ/d4V4ydKFm8wtH3YbPdGy7nQEVkFGknEDWrnDM86hr4c+mkGaBTsj2b5sBOP3D/G3F6vXqZOi7S2UZL8lOJb684Wkg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] ide: remove stale comments from ide-dma.c
Date: Fri, 22 Feb 2008 23:54:11 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200802222224.53642.bzolnier@gmail.com> <47BF4043.8080802@rtr.ca>
In-Reply-To: <47BF4043.8080802@rtr.ca>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802222354.11953.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008, Mark Lord wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > - ide-dma.c is not a separate module
> > 
> > - ide-dma.c is not PCI specific anymore
> > 
> > - DMA is enabled by default nowadays
> > 
> > - link for Intel Zappa BIOS is dead
> > 
> > etc.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/ide-dma.c |   48 ------------------------------------------------
> >  1 file changed, 48 deletions(-)
> > 
> > Index: b/drivers/ide/ide-dma.c
> > ===================================================================
> > --- a/drivers/ide/ide-dma.c
> > +++ b/drivers/ide/ide-dma.c
> > @@ -11,49 +11,6 @@
> >   */
> >  
> >  /*
> > - * This module provides support for the bus-master IDE DMA functions
> > - * of various PCI chipsets, including the Intel PIIX (i82371FB for
> > - * the 430 FX chipset), the PIIX3 (i82371SB for the 430 HX/VX and 
> > - * 440 chipsets), and the PIIX4 (i82371AB for the 430 TX chipset)
> > - * ("PIIX" stands for "PCI ISA IDE Xcellerator").
> > - *
> > - * Pretty much the same code works for other IDE PCI bus-mastering chipsets.
> > - *
> > - * DMA is supported for all IDE devices (disk drives, cdroms, tapes, floppies).
> ..
> 
> Those top comments still look relevant, or at least as relevant
> as the rest of the file (and subsystem) itself.  :)
> 
> Sigh.

ide-dma.c supports _much_ more than IDE PCI BM-DMA nowadays :)

[ hmm, it probably makes sense to split CONFIG_BLK_DEV_IDEDMA_SFF code
  to a separate file (ide-dma-sff.c?) so ide-dma.c would contain only
  generic code ]

anyway here goes "take 2":

[...]
v2:
* Some comments should be preserved. (Noticed by Mark Lord)

Cc: Mark Lord <liml@rtr.ca>
[...]

interdiff:

diff -u b/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
--- b/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -1,9 +1,13 @@
 /*
+ *  IDE DMA support (including IDE PCI BM-DMA).
+ *
  *  Copyright (C) 1995-1998   Mark Lord
  *  Copyright (C) 1999-2000   Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2004, 2007  Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
+ *
+ *  DMA is supported for all IDE devices (disk drives, cdroms, tapes, floppies).
  */
 
 /*
