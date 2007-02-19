Return-Path: <linux-kernel-owner+w=401wt.eu-S932739AbXBSWUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbXBSWUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932864AbXBSWUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:20:10 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:40983 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744AbXBSWUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:20:08 -0500
Date: Mon, 19 Feb 2007 23:20:28 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] ide: make ide_hwif_t.ide_dma_host_on void
Message-ID: <20070219222028.GA9297@aepfle.de>
References: <20070203135301.2546.54884.sendpatchset@localhost.localdomain> <20070203135307.2546.94874.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070203135307.2546.94874.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, Bartlomiej Zolnierkiewicz wrote:

> [PATCH] ide: make ide_hwif_t.ide_dma_host_on void

> +++ b/drivers/ide/ppc/pmac.c
> @@ -1984,10 +1984,8 @@ static void pmac_ide_dma_host_off(ide_dr
>  {
>  }
>  
> -static int
> -pmac_ide_dma_host_on (ide_drive_t *drive)
> +static int pmac_ide_dma_host_on(ide_drive_t *drive)
>  {
> -	return 0;
>  }
>  
>  static int

This missed the s/int/void/
