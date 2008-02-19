Return-Path: <linux-kernel-owner+w=401wt.eu-S1759717AbYBSNCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbYBSNCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYBSNCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:02:42 -0500
Received: from homer.mvista.com ([63.81.120.155]:4716 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752802AbYBSNCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:02:41 -0500
Message-ID: <47BAD3AE.7060906@ru.mvista.com>
Date: Tue, 19 Feb 2008 16:03:42 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] ide: add ide-4drives host driver
References: <20080216163856.10174.72546.sendpatchset@localhost.localdomain> <20080216163911.10174.58246.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216163911.10174.58246.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> CONFIG_BLK_DEV_4DRIVES deserves its own host driver:

> * Add drivers/ide/legacy/ide-4drives.c and move "4drives" support there.

> * Add ide-4drives.o in the link order after all other legacy host
>   drivers enabled by "ide0=" options (they all are mutually exclusive).

> * Make ide-4drives host driver probe itself for IDE devices instead of
>   indirectly depending on ide_generic host driver.

> * Add "probe" module parameter to ide-4drives and update documentation.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Index: b/drivers/ide/Kconfig
> ===================================================================
> --- a/drivers/ide/Kconfig
> +++ b/drivers/ide/Kconfig
> @@ -1042,8 +1042,8 @@ config BLK_DEV_4DRIVES
>  	  Certain older chipsets, including the Tekram 690CD, use a single set
>  	  of I/O ports at 0x1f0 to control up to four drives, instead of the
>  	  customary two drives per port. Support for this can be enabled at
> -	  runtime using the "ide0=four" kernel boot parameter if you say Y
> -	  here.
> +	  runtime using the "ide_4drives.probe" kernel boot parameter if you

    Not "ide-4drives.probe?
    Looks correct otherwise.

MBR, Sergei
