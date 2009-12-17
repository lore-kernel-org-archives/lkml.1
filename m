Return-Path: <linux-kernel-owner+w=401wt.eu-S965012AbZLQLeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012AbZLQLeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 06:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964995AbZLQLeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 06:34:14 -0500
Received: from hmcexedge01.ikoula.com ([78.24.135.21]:33974 "EHLO
	mail.hmc.ikoula.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964992AbZLQLeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 06:34:13 -0500
From: Romain Kubany <rkubany@ikoula.com>
To: Jeff Garzik <jeff@garzik.org>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Date: Thu, 17 Dec 2009 12:34:08 +0100
Subject: RE: Possible regression of LBA48 support for piix
Thread-Topic: Possible regression of LBA48 support for piix
Thread-Index: Acp/CMNKGQxR/gnCSu6dArPEsqSOowAA1cXg
Message-ID: <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB301@HMCEXMBX01CLUS.hmcikoula.com>
References: <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2AF@HMCEXMBX01CLUS.hmcikoula.com>
 <19241.63911.160765.909812@pilspetsen.it.uu.se>
 <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2C1@HMCEXMBX01CLUS.hmcikoula.com>
 <4B2A1008.9070202@garzik.org>
In-Reply-To: <4B2A1008.9070202@garzik.org>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your concern. :)

Here is the full dmesg output : http://pastebin.com/f484004a5 (2.6.28 with same config as in my previous mail)

I'm going to test a 2.6.32.1 kernel and similar config

-----Message d'origine-----
De : linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] De la part de Jeff Garzik
Envoyé : jeudi 17 décembre 2009 12:04
À : Romain Kubany
Cc : Mikael Pettersson; linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org
Objet : Re: Possible regression of LBA48 support for piix

On 12/17/2009 05:04 AM, Romain Kubany wrote:
> Ok, thanks for the prompt reply and the notice for the cc: :)
> I'm using libata and ata_piix now.
> My disk is seen as "sda" and a lshw is reporting the controler as using "ata_piix" :
>
> # lshw -c STORAGE
>    *-ide
>         description: IDE interface
>         product: 82371AB/EB/MB PIIX4 IDE
>         vendor: Intel Corporation
>         physical id: 7.1
>         bus info: pci@0000:00:07.1
>         logical name: scsi0
>         logical name: scsi1
>         version: 01
>         width: 32 bits
>         clock: 33MHz
>         capabilities: ide bus_master emulated
>         configuration: driver=ata_piix latency=0
>
> But fdisk always recognize the disk as 136.8Gb :
>
> # fdisk -l
>
> Disk /dev/sda: 136.8 GB, 136899993600 bytes
> 16 heads, 63 sectors/track, 265260 cylinders
> Units = cylinders of 1008 * 512 = 516096 bytes
> Disk identifier: 0xd7267427
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *           1         204      102815+  83  Linux
> /dev/sda2             205        2236     1024128   82  Linux swap / Solaris
> /dev/sda3            2237       20805     9358776   83  Linux
>
> Here is the new kernel config file : http://pastebin.com/f65fd472b

I would definitely be interested in seeing the 'dmesg' output for 
libata, and results from a more recent kernel.

	Jeff



--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

