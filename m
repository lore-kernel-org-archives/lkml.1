Return-Path: <linux-kernel-owner+w=401wt.eu-S1750755AbXCDU4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750755AbXCDU4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 15:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbXCDU4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 15:56:40 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46028 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750755AbXCDU4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 15:56:39 -0500
Date: Sun, 4 Mar 2007 22:00:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][libata] pata_pdc202xx_old: fix data corruption and
 other problems
Message-ID: <20070304220046.44ccd7b0@lxorguk.ukuu.org.uk>
In-Reply-To: <200703040158.43471.bzolnier@gmail.com>
References: <200703040158.43471.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2007 01:58:43 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> 
> [PATCH] pata_pdc202xx_old: fix data corruption and other problems
> 
> Fix wrong "port" calculations in pdc202xx_configure_piomode()
> and pdc202xx_set_dmamode(), it was horribly broken which resulted
> in major havoc on all configurations except one (master device on
> primary channel, no other devices) as code was writing PIO/DMA
> timings and device settings to wrong registers (including
> reserved ones),

Thanks

Acked-by: Alan Cox <alan@redhat.com>

