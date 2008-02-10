Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbYBJQvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbYBJQvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 11:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYBJQvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 11:51:03 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:48644 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYBJQvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 11:51:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=vzCG+KXGy4L3Ip/JQ9LwqrV0O3lvx3eaOhXlN5gPAJ1BzGudb40M3Toenf9eshsbSirvperyyKWBUhso3dHkA9cTJ4WlbNydBuLK++wPF8tp5jTZJ6E4lAepMVcgrkHYYVBg0MvOvHMAQSGfOjpMVWCxWBZxdvbxuulyi90qQ1Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH 7/8] ide: add struct ide_port_info instances to legacy host drivers
Date: Sun, 10 Feb 2008 18:04:48 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain> <20080106170310.6861.14522.sendpatchset@localhost.localdomain> <20080211.010729.115910395.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080211.010729.115910395.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802101804.49154.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008, Atsushi Nemoto wrote:
> On Sun, 06 Jan 2008 18:03:10 +0100, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > +	/* reset DMA masks only for SFF-style DMA controllers */
> > +	if ((d->host_flags && IDE_HFLAG_NO_DMA) == 0 && hwif->dma_base == 0)
> > +		hwif->swdma_mask = hwif->mwdma_mask = hwif->ultra_mask = 0;
> 
> It might be too late, but "host_flags && IDE_HFLAGS_NO_DMA" seems
> wrong for me.

It is too late for -git but not too late for 2.6.25-rc1. ;-)

Could you make a patch please?

Thanks,
Bart
