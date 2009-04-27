Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbZD0Tge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbZD0Tge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbZD0Tg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:36:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:51865 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbZD0TgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:36:25 -0400
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <2CE2BC61-1C6B-4D01-870B-BC460730AD79@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
In-Reply-To: <20090424223355.GB7858@ime.usp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] powerpc: minimizing the configuration of linkstation_defconfig
Date: Mon, 27 Apr 2009 14:29:52 -0500
References: <20090424065816.GA15525@ime.usp.br> <Pine.LNX.4.64.0904242158210.8309@axis700.grange> <20090424223355.GB7858@ime.usp.br>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 24, 2009, at 5:33 PM, Rogério Brito wrote:

> This patch addresses the following issues:
>
>
> 01. makes CFQ the default scheduler, to be in line with the rest of  
> the kernel.
>
> 02. since linkstations are meant to store files, enable large blk  
> devices.
>
> 03. disable CONFIG_MIGRATION in in such low memory devices.
>
> 04. disable CONFIG_BLK_DEV_RAM.

do we not allow booting a ramdisk?

> 05. disable CONFIG_SCSI_LOWLEVEL, as no device under that tree is  
> used.
>
> 06. idem for CONFIG_NETDEV_10000.
>
> 07. idem for CONFIG_WIRELESS.
>
> 08. idem for CONFIG_HWMON.
>
> 09. idem for CONFIG_CRYPTO_HW.
>
> 10. disable CONFIG_VIDEO_OUTPUT_CONTROL.
>
> 11. keep consistency and disable extended attributes in CIFS, ext3,  
> and NFS.
>
> 12. enable CONFIG_PRINTK_TIME.
>
> Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
>
> ---
>
> Dear Kumar, please, apply this one.
>
> I have another patch regarding one regression regarding MTD &
> PHYSMAP_COMPAT that I plan to send on top of this one.
>
> Thanks.

Ok, can we look at just specifying such info in the linkstation device  
tree.

Also, can you break this defconfig update into two patches.  1. that  
just updates to 2.6.30-rc3 (or latest) and 2. that makes the various  
changes you've listed above.

- k