Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbYDLS5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbYDLS5X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYDLS5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:57:13 -0400
Received: from h155.mvista.com ([63.81.120.155]:45197 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752906AbYDLS5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:57:12 -0400
Message-ID: <480105DE.6040904@ru.mvista.com>
Date: Sat, 12 Apr 2008 22:56:30 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ide: remove ->dma_prdtable field from ide_hwif_t
References: <200804122105.42636.bzolnier@gmail.com>
In-Reply-To: <200804122105.42636.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Use 'hwif->dma_base + {4,8}' instead of hwif->dma_prdtable in
>   {ide,scc}_dma_setup().

> * Remove no longer needed ->dma_prdtable field from ide_hwif_t.

> While at it:

> * Use ATA_DMA_TABLE_OFS define.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei

