Return-Path: <linux-kernel-owner+w=401wt.eu-S1762594AbYBSWEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594AbYBSWEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761914AbYBSWEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:04:01 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:2285 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760393AbYBSWD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:03:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Zy0F5YrEMaReyw6ruCHzzf323+UXII7+XxwybG++PlXsfHghJxUV2mVrJqiUfuVk/Xq/cdiVlMA2N/l7Ud0IL2RI9LJ/AFXbdFsVPzDt/GFScej+PheMHa4em/d5msJ3u0rtrbuIzMEKO1WvO8CCw8JTtLLPjZb1DZ4pCFCwwNU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 03/12] ide: add ide-4drives host driver
Date: Tue, 19 Feb 2008 22:24:35 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080216163856.10174.72546.sendpatchset@localhost.localdomain> <20080216163911.10174.58246.sendpatchset@localhost.localdomain> <47BAD3AE.7060906@ru.mvista.com>
In-Reply-To: <47BAD3AE.7060906@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802192224.36088.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> > CONFIG_BLK_DEV_4DRIVES deserves its own host driver:
> 
> > * Add drivers/ide/legacy/ide-4drives.c and move "4drives" support there.
> 
> > * Add ide-4drives.o in the link order after all other legacy host
> >   drivers enabled by "ide0=" options (they all are mutually exclusive).
> 
> > * Make ide-4drives host driver probe itself for IDE devices instead of
> >   indirectly depending on ide_generic host driver.
> 
> > * Add "probe" module parameter to ide-4drives and update documentation.
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> > Index: b/drivers/ide/Kconfig
> > ===================================================================
> > --- a/drivers/ide/Kconfig
> > +++ b/drivers/ide/Kconfig
> > @@ -1042,8 +1042,8 @@ config BLK_DEV_4DRIVES
> >  	  Certain older chipsets, including the Tekram 690CD, use a single set
> >  	  of I/O ports at 0x1f0 to control up to four drives, instead of the
> >  	  customary two drives per port. Support for this can be enabled at
> > -	  runtime using the "ide0=four" kernel boot parameter if you say Y
> > -	  here.
> > +	  runtime using the "ide_4drives.probe" kernel boot parameter if you
> 
>     Not "ide-4drives.probe?
>     Looks correct otherwise.

I believe that both versions are correct but I fixed this in 'take 3' to
be on the safe side.

Thanks,
Bart
