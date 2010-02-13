Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab0BMWtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:49:22 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:44482 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0BMWtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:49:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nvTfL//sYWP4FbvlsUJg1zEU+5TH1nRqoOsZenl53Edu1UywnctgBWBfdNzc6PBAkW
         peffJ8Jnoj45k1qS1GGdN8L8fYhBOPFe40NEnRsSZoIuwsQ6J9xn8blSIbEIGBWRP3Kw
         q+AxUcZypOvYrOktrO03nkgezABunatxbfByY=
Message-ID: <4B772C6D.5000600@pobox.com>
Date: Sat, 13 Feb 2010 17:49:17 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
CC: Frans Pop <elendil@planet.nl>, knan-lkml@anduin.net, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] non-existant config in kernel source (CONFIG_AHCI)
References: <20100205132959.GB6874@faui49.informatik.uni-erlangen.de> <201002051457.04135.elendil@planet.nl> <20100205152635.GC7299@faui49.informatik.uni-erlangen.de>
In-Reply-To: <20100205152635.GC7299@faui49.informatik.uni-erlangen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2010 10:26 AM, Christoph Egger wrote:
> On Fri, Feb 05, 2010 at 02:57:00PM +0100, Frans Pop wrote:
>> Christoph Egger wrote:
>>> --- a/drivers/ata/pata_marvell.c
>>> +++ b/drivers/ata/pata_marvell.c
>>> @@ -147,7 +147,7 @@ static int marvell_init_one (struct pci_dev *pdev,
>>> 	if (pdev->device == 0x6101)
>>> 		ppi[1] =&ata_dummy_port_info;
>>>
>>> -#if defined(CONFIG_AHCI) || defined(CONFIG_AHCI_MODULE)
>>> +#if defined(CONFIG_SATA_AHCI) || defined(SATA_CONFIG_AHCI_MODULE)
>>
>> Shouldn't the last be CONFIG_SATA_AHCI_MODULE ?
>
> Right my fault. Updated patch below
>
> -----
>> From 60136f94d9c97f9a788738e30731e25bd794322b Mon Sep 17 00:00:00 2001
> From: Christoph Egger<siccegge@stud.informatik.uni-erlangen.de>
> Date: Fri, 5 Feb 2010 13:26:33 +0100
> Subject: [PATCH] CONFIG_AHCI is really CONFIG_SATA_AHCI
>
> The marvell driver comtains a fallback to ahci for the sata ports
> which is incorrectly checked as CONFIG_AHCI while the only AHCI config
> item is actually called SATA_AHCI (which also sounds sensible
> considering it's a fallback for the sata ports).
>
> Signed-off-by: Christoph Egger<siccegge@stud.informatik.uni-erlangen.de>
> ---
>   drivers/ata/pata_marvell.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

applied


