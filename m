Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYIBVyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYIBVyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYIBVy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:54:29 -0400
Received: from h155.mvista.com ([63.81.120.155]:16324 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751675AbYIBVy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:54:28 -0400
Message-ID: <48BDB60F.1070806@ru.mvista.com>
Date: Wed, 03 Sep 2008 01:54:23 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] ide: make ide_dma_timeout() available also for CONFIG_BLK_DEV_IDEDMA_SFF=n
References: <20080902194711.14564.63625.sendpatchset@localhost.localdomain> <20080902194726.14564.348.sendpatchset@localhost.localdomain>
In-Reply-To: <20080902194726.14564.348.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Make ide_dma_timeout() available also for CONFIG_BLK_DEV_IDEDMA_SFF=n
> and convert {ics,au1xxx-}ide.c to use it.
>
> While at it:
> - dump ATA Status register content on error
> - use EXPORT_SYMBOL_GPL() to match the rest of SFF DMA functions
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


