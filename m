Return-Path: <linux-kernel-owner+w=401wt.eu-S1760455AbYCUSJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbYCUSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYCUSJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:09:17 -0400
Received: from ns2.mvista.com ([63.81.120.155]:4250 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756688AbYCUSJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:09:16 -0400
Message-ID: <47E3FA15.9000008@ru.mvista.com>
Date: Fri, 21 Mar 2008 21:10:29 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/1] IDE: fix ide.h compiler warning
References: <1205683318-1409-1-git-send-email-jirislaby@gmail.com> <200803181419.08687.bzolnier@gmail.com>
In-Reply-To: <200803181419.08687.bzolnier@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: do complete DMA setup in ->init_dma method (take 2)

> * Make ide_hwif_setup_dma() return an error value.

> * Pass 'const struct ide_port_info *d' instead of 'unsigned long dmabase'
>   to ->init_dma method and make it return an error value.

> * Rename ide_get_or_set_dma_base() to ide_pci_dma_base(),
>   change ordering of its arguments and then export it.

> * Export ide_pci_set_master().

> * Do complete DMA setup inside ->init_dma method and update ->init_dma
>   users accordingly.

> * Sanitize code for DMA setup in ide_init_port().

> v2:
> * Fix for CONFIG_BLK_DEV_IDEDMA_PCI=n configs
>   (from Jiri Slaby <jirislaby@gmail.com>):

>   Fix following compiler warning by returning EINVAL:

>   In file included from ANYTHING-INCLUDING-IDE.H:45:
>   include/linux/ide.h: In function ‘ide_hwif_setup_dma’:
>   include/linux/ide.h:1022: warning: no return statement in function returning non-void

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
