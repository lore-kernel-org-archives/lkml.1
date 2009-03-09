Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbZCIRwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbZCIRwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZCIRwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:52:01 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:9220 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751552AbZCIRwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:52:00 -0400
X-BigFish: VPS-33(zcb8kz1432R98dR936eQ1805M9371P19c2kzzzzed1kz2fh6bh65h)
X-Spam-TCS-SCL: 4:0
Message-ID: <49B5572F.4010007@am.sony.com>
Date: Mon, 9 Mar 2009 10:51:43 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jim Paris <jim@jtan.com>,
       Vivien Chappelier <vivien.chappelier@free.fr>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ps3/block: Replace mtd/ps3vram by block/ps3vram
References: <alpine.LRH.2.00.0903041444300.32279@vixen.sonytel.be> <1236209255.6696.75.camel@pasglop> <20090305065423.GK11787@kernel.dk> <alpine.LRH.2.00.0903061349010.16809@vixen.sonytel.be>
In-Reply-To: <alpine.LRH.2.00.0903061349010.16809@vixen.sonytel.be>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2009 17:51:44.0641 (UTC) FILETIME=[B5E20710:01C9A0DF]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2009 04:54 AM, Geert Uytterhoeven wrote:
> Convert the PS3 Video RAM Storage Driver from an MTD driver to a plain block
> device driver.
> 
> The ps3vram driver exposes unused video RAM on the PS3 as a block device
> suitable for storage or swap.  Fast data transfer is achieved using a local
> cache in system RAM and DMA transfers via the GPU.
> 
> The new driver is ca. 50% faster for reading, and ca. 10% for writing.
> 
>  arch/powerpc/platforms/ps3/Kconfig |    7 +
>  drivers/block/Makefile             |    1 +
>  drivers/block/ps3vram.c            |  865 ++++++++++++++++++++++++++++++++++++
>  drivers/mtd/devices/Kconfig        |    7 -
>  drivers/mtd/devices/Makefile       |    1 -
>  drivers/mtd/devices/ps3vram.c      |  768 --------------------------------
>  6 files changed, 873 insertions(+), 776 deletions(-)
>  create mode 100644 drivers/block/ps3vram.c
>  delete mode 100644 drivers/mtd/devices/ps3vram.c

Looks good, certainly an improvement.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

