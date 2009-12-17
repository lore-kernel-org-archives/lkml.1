Return-Path: <linux-kernel-owner+w=401wt.eu-S1764395AbZLQLDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764395AbZLQLDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 06:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764382AbZLQLDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 06:03:41 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54844 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764373AbZLQLDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 06:03:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=H9bh5LomxBLIAgV/Uld26JG3xFDABitJ3fwJkHIuChWEntVxxMoce+29SrgUXmwtzw
         jYS4x7LJlT0Rc0fMgnBRmzSh1VzqZzpGWAUBuWSeT4II6VUYcxRP7NlDNuKeIlpJDBZH
         weymWRFkhiWLPqxSjbvfP2dIvm9ZC1iIJoT2o=
Message-ID: <4B2A1008.9070202@garzik.org>
Date: Thu, 17 Dec 2009 06:03:36 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Romain Kubany <rkubany@ikoula.com>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Possible regression of LBA48 support for piix
References: <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2AF@HMCEXMBX01CLUS.hmcikoula.com> <19241.63911.160765.909812@pilspetsen.it.uu.se> <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2C1@HMCEXMBX01CLUS.hmcikoula.com>
In-Reply-To: <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2C1@HMCEXMBX01CLUS.hmcikoula.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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



