Return-Path: <linux-kernel-owner+w=401wt.eu-S965531AbXBSXPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965531AbXBSXPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 18:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965533AbXBSXPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 18:15:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:51537 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965531AbXBSXPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 18:15:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=BWzq/5biVHw/kWiUFXgpJJAjSuR0i8shv/XzjvAMFTUw/I9gjflrN0uOJmTvqlBnJeNmGJQr+6ZcxH3h0NzPwYjpSBUpAgdO7+Z3lbOIhVnVsoEclHsPQApMb2RXj7sjQbtkyAUDiyPmf64ym1M3OZocXfxOa9tdUqUrj+vZep4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH 12/15] ide: make ide_hwif_t.ide_dma_host_on void
Date: Tue, 20 Feb 2007 00:21:07 +0100
User-Agent: KMail/1.9.5
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20070203135301.2546.54884.sendpatchset@localhost.localdomain> <20070203135307.2546.94874.sendpatchset@localhost.localdomain> <20070219222028.GA9297@aepfle.de>
In-Reply-To: <20070219222028.GA9297@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702200021.07419.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 19 February 2007 23:20, Olaf Hering wrote:
> On Sat, Feb 03, Bartlomiej Zolnierkiewicz wrote:
> 
> > [PATCH] ide: make ide_hwif_t.ide_dma_host_on void
> 
> > +++ b/drivers/ide/ppc/pmac.c
> > @@ -1984,10 +1984,8 @@ static void pmac_ide_dma_host_off(ide_dr
> >  {
> >  }
> >  
> > -static int
> > -pmac_ide_dma_host_on (ide_drive_t *drive)
> > +static int pmac_ide_dma_host_on(ide_drive_t *drive)
> >  {
> > -	return 0;
> >  }
> >  
> >  static int
> 
> This missed the s/int/void/

yes, sorry for that

akpm has fixed this along with other things in pmac driver
and the patch is already in the IDE quilt tree

Bart
