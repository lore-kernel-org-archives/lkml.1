Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZKSSV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZKSSV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZKSSV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:21:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37697 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752904AbZKSSV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:21:27 -0500
Date: Thu, 19 Nov 2009 18:23:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pata_hpt37x: add proper cable detection methods
Message-ID: <20091119182325.21a23953@lxorguk.ukuu.org.uk>
In-Reply-To: <200911191910.44609.bzolnier@gmail.com>
References: <200911191910.44609.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009 19:10:44 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/pata_hpt37x.c |   86 +++++++++++++++++++++++++++++-----------------
>  1 file changed, 56 insertions(+), 30 deletions(-)
> 
> Index: b/drivers/ata/pata_hpt37x.c

Acked-by: Alan Cox <alan@linux.intel.com>

I suspect this may also need the udelay(10) adding but even if it does
its cleaner this way.
