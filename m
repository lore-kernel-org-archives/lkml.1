Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbZFKCq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbZFKCq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZFKCqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:46:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:54960 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbZFKCqt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:46:49 -0400
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <3167CCB7-E635-416C-AA99-62033E73AF87@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
In-Reply-To: <20090516160453.GA15138@ime.usp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH] powerpc: minimizing the configuration of linkstation_defconfig
Date: Wed, 10 Jun 2009 21:46:38 -0500
References: <20090424065816.GA15525@ime.usp.br> <Pine.LNX.4.64.0904242158210.8309@axis700.grange> <20090424223355.GB7858@ime.usp.br> <2CE2BC61-1C6B-4D01-870B-BC460730AD79@kernel.crashing.org> <20090428133200.GB12828@ime.usp.br> <20090516160453.GA15138@ime.usp.br>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 16, 2009, at 11:04 AM, Rogério Brito wrote:

> Hi, Kumar, Guennadi, and Co.
>
>
> This patch addresses the following issues:
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
>
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
> This is the patch for tidying the defconfig. I'm still having issues
> with the MTD devices, it seems. :-( I will investigate this now.
>
> I can send a similar patch to storcenter.

Did you ever resolve the MTD issue?

- k