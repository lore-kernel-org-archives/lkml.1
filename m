Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYGUTWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYGUTWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbYGUTVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:21:53 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:56584 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754670AbYGUTVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:21:51 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=danhDmx_AAAA:8 a=6_KQHWhckS0sEaYz_MUA:9 a=CoNV3Q_yI5IV2W1R30kA:7 a=BaHlNAaCjdGVEqediFW4E_8z5S0A:4 a=2eKvNQJKnqYA:10 a=lBRciGGoxdUA:10 a=bP5oxE-NhY0A:10 a=39ovIxkSX3oA:10
Message-ID: <4884E1CF.2060405@shaw.ca>
Date: Mon, 21 Jul 2008 13:21:51 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Chuck Short <zulcss@ubuntu.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/7] ata: blacklist FUJITSU MHW2160BH PL
References: <fa.ALyrA5g+KD/4GlXdcY53hIWqKUs@ifi.uio.no> <fa.DCjHMBBwNh4jCV7S5sRgLaXPnZo@ifi.uio.no>
In-Reply-To: <fa.DCjHMBBwNh4jCV7S5sRgLaXPnZo@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Short wrote:
> Reference: https://launchpad.net/bugs/175834
> 
> CC: linux-ide@vger.kernel.org
> Signed-off-by: Chuck Short <zulcss@ubuntu.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Ben Collins <ben.collins@canonical.com>
> ---
>  drivers/ata/libata-core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 9bef1a8..2664082 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -3935,6 +3935,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
>  	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
>  	{ "HTS541080G9SA00",    "MB4OC60D",     ATA_HORKAGE_NONCQ, },
>  	{ "HTS541010G9SA00",    "MBZOC60D",     ATA_HORKAGE_NONCQ, },
> +	{ "FUJITSU MHW2160BH PL", "0084001E",   ATA_HORKAGE_NONCQ, },
>  
>  	/* devices which puke on READ_NATIVE_MAX */
>  	{ "HDS724040KLSA80",	"KFAOA20N",	ATA_HORKAGE_BROKEN_HPA, },

NACK, this report is based on spurious NCQ completions in ahci which 
were found to be bogus and the detection was removed in later kernels.
