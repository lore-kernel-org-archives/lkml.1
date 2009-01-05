Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbZAEVVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbZAEVVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZAEVVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:21:01 -0500
Received: from h155.mvista.com ([63.81.120.155]:64610 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751871AbZAEVVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:21:00 -0500
Message-ID: <496279B6.5080802@ru.mvista.com>
Date: Tue, 06 Jan 2009 00:20:54 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ide: can't use SSD/non-rotational queue flag for all
 CFA devices
References: <200901051951.29692.bzolnier@gmail.com>
In-Reply-To: <200901051951.29692.bzolnier@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Some rotating disks also present themselves as CFA devices.
>
> Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/ide-disk.c
> ===================================================================
> --- a/drivers/ide/ide-disk.c
> +++ b/drivers/ide/ide-disk.c
> @@ -633,7 +633,7 @@ static void ide_disk_setup(ide_drive_t *
>  	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name,
>  		q->max_sectors / 2);
>  
> -	if (ata_id_is_ssd(id) || ata_id_is_cfa(id))
> +	if (ata_id_is_ssd(id))
>  		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
>  
>  	/* calculate drive capacity, and select LBA if possible */
> N‹§²æìr¸›yúèšØb²X¬¶Ç§vØ^–)Şº{.nÇ+‰·¥Š{±‰×¢Ø^n‡r¡ö¦zËëh™¨è­Ú&¢ø®G«éh®(­éšŠİ¢j"ú¶m§ÿïêäz¹Ş–Šàşf£¢·hšˆ§~ˆmml==

Hm, why your Kmail base64-encodes plain English messages and adds this 
kind of binary crap?

MBR, Sergei


