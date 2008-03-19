Return-Path: <linux-kernel-owner+w=401wt.eu-S1161905AbYCSWkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161905AbYCSWkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936489AbYCSVLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:11:55 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:39514 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441AbYCSVLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:11:51 -0400
Message-ID: <47E0FC47.8040902@gmail.com>
Date: Wed, 19 Mar 2008 20:43:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803190853.10030.volker.armin.hemmann@tu-clausthal.de> <47E0D5C8.9070005@gmail.com> <200803191108.18577.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200803191108.18577.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Volker Armin Hemmann wrote:
> On Mittwoch, 19. März 2008, Tejun Heo wrote:
>> x UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200
>>
>>> irq 315
>>> [   38.125479] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port
>>> 0xf9dfc280 irq 315
>>> [   38.597035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>> [   38.597732] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max
>>> UDMA/133 [   38.597775] ata1.00: 312581808 sectors, multi 16: LBA48
>>> [   38.598405] ata1.00: configured for UDMA/133
>>> [   39.069342] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>> [   39.084225] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
>>> [   39.084264] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth
>>> 0/32) [   39.086268] ata2.00: configured for UDMA/133
>> So, just to confirm.  With the updated patch, you don't see any problem,
>> right?
> 
> Correct. With the updated patch I don't see problems in 'non-raid' mode. AHCI 
> mode still has problems without nosmi. But that is an entirely different 
> problem, right?

Yeap, can you please post the result of "lspci -nn"?

-- 
tejun
