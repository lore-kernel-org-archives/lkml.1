Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbYG2Nev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbYG2Nev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYG2Nel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:34:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60169 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbYG2Nel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:34:41 -0400
Message-ID: <488F1C6C.9000002@garzik.org>
Date: Tue, 29 Jul 2008 09:34:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: gshan <gshan@alcatel-lucent.com>
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: PIIX4: DMA timeout issue
References: <488ED837.2060509@alcatel-lucent.com>
In-Reply-To: <488ED837.2060509@alcatel-lucent.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gshan wrote:
> Hello, I sent mails on this issue before, but nobody made response.
> There are 2 types of board for me. The hardware configuration for
> those 2 boards are almost same except that one of them has 100GB
> harddisk, and another type of board has 60GB harddisk. All harddisk
> was access through PIIX4. I found this issue on board with 60GB
> disk, but can't reproduce it on that with 100GB disk.
> 
> When I uncompressed a large file (600MB) to a logic partition with 8GB
> size, following errors was report on middle way (5 minutes about from 
> start).
> Anybody has ideas?
> 
> hdc: dma_timer_expiry: dma status == 0x21
> hdc: DMA timeout error
> hdc: dma timeout error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: DMA disabled
> ide1: reset: success

Can you try disabling the IDE driver (CONFIG_IDE) and enabling the newer 
libata driver?  (CONFIG_ATA)

	Jeff




