Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbXHXA45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbXHXA45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764058AbXHXA4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:56:48 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:37747 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763673AbXHXA4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:56:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JiCP7Hsx9d8v81Pa34/2Yyo93mN5lfonq50tqZZhSN5UYB/UK9kuwEGMnT3lZsJp3Pm0LTOxBNHM7/0D1OJvQZVS5eRxYAibjxIJkJ2QOeFCcyrKq8Fs86o1FycKjw6Uzwm43LuvKu1aejry7/HgCG9S9aqxj6UqsnZS15MasRs=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/30] Remove unneeded casts of [kv][mzc]alloc() return values
Date: Fri, 24 Aug 2007 02:53:54 +0200
User-Agent: KMail/1.9.7
Cc: Jesper Juhl <jesper.juhl@gmail.com>
References: <200708240135.56833.jesper.juhl@gmail.com>
In-Reply-To: <200708240135.56833.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708240253.54106.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/08/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
[snip]
> The patches in this series are
> 
Damn, I managed to mess up that list. Here's how it should have looked : 

 [PATCH 01/30] ia64: Remove unnecessary cast of allocation return value in sn_hwperf_enum_objects()
 [PATCH 02/30] cris: Remove unnecessary cast of allocation return value in intmem.c
 [PATCH 03/30] um: Don't unnecessarily cast allocation return value in ubd_kern.c
 [PATCH 04/30] powerpc: Don't cast kmalloc return value in ibmebus.c
 [PATCH 05/30] atm: No need to cast vmalloc() return value
 [PATCH 06/30] i2o: No need to cast kmalloc() return value in cfg_open()
 [PATCH 07/30] mtd: Get rid of pointless cast of kzalloc() return value in AT26xxx driver
 [PATCH 08/30] mtd: Avoid a pointless kmalloc() return value cast in TQM8xxL mapping handling code
 [PATCH 09/30] mtd: Don't cast kmalloc() return value in drivers/mtd/maps/pmcmsp-flash.c
 [PATCH 10/30] irda: Do not do pointless kmalloc return value cast in KingSun driver
 [PATCH 11/30] net: No need to cast vmalloc() return values in NetXen NIC driver
 [PATCH 12/30] net: No point in casting kmalloc return values in Gianfar Ethernet Driver
 [PATCH 13/30] net: Don't do pointless kmalloc return value casts in zd1211 driver
 [PATCH 14/30] net: Kill some unneeded allocation return value casts in libertas
 [PATCH 15/30] net: No need to cast kmalloc() return value in ipw2100 driver
 [PATCH 16/30] net: Avoid pointless allocation casts in BSD compression module
 [PATCH 17/30] isdn: Get rid of some pointless allocation casts in common and bsd comp.
 [PATCH 18/30] isdn: eicon - get rid of a pointless vmalloc() return value cast
 [PATCH 19/30] scsi: Remove explicit casts of [kv]alloc return values in osst driver
 [PATCH 20/30] scsi: In the Advansys driver, do not cast allocation function return values
 [PATCH 21/30] oss: Remove unneeded vmalloc() return value casts in OSS
 [PATCH 22/30] ivtv: kzalloc() returns void pointer, no need to cast
 [PATCH 23/30] video: Remove pointless kmalloc() return value cast in Zoran PCI controller driver
 [PATCH 24/30] dvb: remove some unneeded vmalloc() return value casts from av7110
 [PATCH 25/30] tty: dont needlessly cast kmalloc() return value
 [PATCH 26/30] md: vmalloc() returns void pointer so we don't need to cast it in dm-ioctl
 [PATCH 27/30] usb: avoid redundant cast of kmalloc() return value in OTi-6858 driver
 [PATCH 28/30] jfs: avoid pointless casts of kmalloc() return val
 [PATCH 29/30] mm: No need to cast vmalloc() return value in zone_wait_table_init()
 [PATCH 30/30] emu10k1: There's no need to cast vmalloc() return value in snd_emu10k1_create()

Kind regards,
  Jesper

