Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYL3Svk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYL3Svk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 13:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYL3Sv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 13:51:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45996 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYL3Sv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 13:51:27 -0500
Date: Tue, 30 Dec 2008 13:51:26 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.27.10: ata1.00: HPA detected: current 293044655, native
	293046768
Message-ID: <20081230185126.GC15235@bombadil.infradead.org>
References: <alpine.DEB.1.10.0812300657050.11356@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812300657050.11356@p34.internal.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 07:26:40AM -0500, Justin Piszcz wrote:
> On one system, two Raptor 150s:
>
> [    0.739402] ata1.00: HPA detected: current 293044655, native 293046768
> [    0.739491] ata1.00: ATA-7: WDC WD1500ADFD-00NLR5, 21.07QR5, max UDMA/133
> [    0.739577] ata1.00: 293044655 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    0.742454] ata1.00: configured for UDMA/133
>
> [    1.059146] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.061406] ata2.00: ATA-7: WDC WD1500ADFD-00NLR5, 21.07QR5, max UDMA/133
> [    1.061494] ata2.00: 293046768 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    1.064360] ata2.00: configured for UDMA/133
>
> Two disks in a RAID-1 (mdadm) configuration, how come the first one
> has an issue w/HPA as the firmware of both disks is the same..?
>
> l1:~# smartctl -a /dev/sda | grep -i bytes
> User Capacity:    150,038,863,360 bytes
> l1:~# smartctl -a /dev/sdb | grep -i bytes
> User Capacity:    150,039,945,216 bytes
> l1:~#
>
> Why does this occur?
>

Bonghits... Anyway, pass libata.ignore_hpa=1 if you want to use the full
capacity of your disk.

regards, Kyle
