Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbXBRF6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbXBRF6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 00:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933121AbXBRF6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 00:58:23 -0500
Received: from muan.mtu.ru ([195.34.34.229]:3090 "EHLO muan.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933120AbXBRF6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 00:58:22 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.20: libata PATA ATAPI CDROM weirdness on ALI
To: Brandon Low <lostlogic@lostlogicx.com>, linux-kernel@vger.kernel.org
Date: Sun, 18 Feb 2007 08:54:39 +0300
References: <20070218045625.GE19788@lostlogicx.com>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20070218055440.AF4D839BCA7@muan.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brandon Low wrote:

> I'm having some weirdness during boot with my optical drives on 2.6.20.
> 
> ata2.00: ATAPI, max UDMA/33
> ata2.01: ATAPI, max UDMA/33
> ata2.00: qc timeout (cmd 0xef)
> ata2.00: failed to set xfermode (err_mask=0x4)
> ata2.00: limiting speed to UDMA/25
> ata2: failed to recover some devices, retrying in 5 secs
> ata2.00: configured for UDMA/25
> ata2.01: configured for UDMA/33
> 
> the 4 lines starting with qc timeout _would_ repeat with lower speeds
> until the drive was finally disabled and then do the same for 2.01,
> except that on this particular attempt, I had the thought to eject both
> optical drives while it sat there.  Boot then proceeded normally and the
> drives appear to work.
> 
> Intuitively this seems to indicate that the drives aren't being sent
> some kind of wake-up call before their transfer modes are set.
> 
> The motherboard is an ASRock 939 Dual SATA II.
> 

In my case of relatively old ALi chipset CD-ROM was never detected if DMA is
allowed. Unfortunately this remained mystery for quite some time. Legacy
IDE drivers are working just fine; it is only pata_ali that failes :(

See e.g. http://marc.theaimsgroup.com/?l=linux-kernel&m=116500554505311&w=2
(2.6.19: ALi M5229 - CD-ROM not found with pata_ali)

if you have any idea how to debug it ...

-andrey


> Let me know if there is any more information that I can provide.
> 
> Thanks,
> 
> Brandon Low


