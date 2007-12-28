Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbXL1MB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbXL1MB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 07:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXL1MBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 07:01:47 -0500
Received: from h155.mvista.com ([63.81.120.155]:7081 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752521AbXL1MBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 07:01:46 -0500
Message-ID: <4774E5C6.90506@ru.mvista.com>
Date: Fri, 28 Dec 2007 15:02:14 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] piix: remove stale comments
References: <20071227191153.1357.63211.sendpatchset@localhost.localdomain> <20071227191200.1357.71766.sendpatchset@localhost.localdomain>
In-Reply-To: <20071227191200.1357.71766.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/pci/piix.c
> ===================================================================
> --- a/drivers/ide/pci/piix.c
> +++ b/drivers/ide/pci/piix.c
> @@ -8,53 +8,8 @@
>   *
>   *  May be copied or modified under the terms of the GNU General Public License
>   *
> - *  PIO mode setting function for Intel chipsets.
> - *  For use instead of BIOS settings.
> + * Documentation:
>   *
> - * 40-41
> - * 42-43
> - * 
> - *                 41
> - *                 43
> - *
> - * | PIO 0       | c0 | 80 | 0 |
> - * | PIO 2 | SW2 | d0 | 90 | 4 |
> - * | PIO 3 | MW1 | e1 | a1 | 9 |
> - * | PIO 4 | MW2 | e3 | a3 | b |
> - *
> - * sitre = word40 & 0x4000; primary
> - * sitre = word42 & 0x4000; secondary
> - *
> - * 44 8421|8421    hdd|hdb
> - *
> - * 48 8421         hdd|hdc|hdb|hda udma enabled
> - *
> - *    0001         hda
> - *    0010         hdb
> - *    0100         hdc
> - *    1000         hdd
> - *
> - * 4a 84|21        hdb|hda
> - * 4b 84|21        hdd|hdc
> - *
> - *    ata-33/82371AB
> - *    ata-33/82371EB
> - *    ata-33/82801AB            ata-66/82801AA
> - *    00|00 udma 0              00|00 reserved
> - *    01|01 udma 1              01|01 udma 3
> - *    10|10 udma 2              10|10 udma 4
> - *    11|11 reserved            11|11 reserved
> - *
> - * 54 8421|8421    ata66 drive|ata66 enable

    You could have left te progarmming info intact...

WBR, Sergei

