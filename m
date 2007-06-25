Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbXFYCjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbXFYCjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 22:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbXFYCjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 22:39:36 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:56095 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbXFYCjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 22:39:35 -0400
Date: Sun, 24 Jun 2007 20:39:27 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 2.6.22-rc5] libata: add HTS541616J9SA00 to NCQ blacklist
In-reply-to: <467F286B.40607@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       enricoss@tiscali.it, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Message-id: <467F2ADF.1040600@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.sspu6LOivd/touNtS2IsMKPqHa0@ifi.uio.no>
 <fa.19XJG1Asdp1zwcWLxolIH6F+5lY@ifi.uio.no> <467EC909.9040006@shaw.ca>
 <467F2495.3080509@gmail.com> <467F286B.40607@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Another member of HTS5416* family doing spurious NCQ completion.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Enrico Sardi <enricoss@tiscali.it>
> ---
>  drivers/ata/libata-core.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index adfae9d..fbca8d8 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -3803,6 +3803,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
>  	/* Drives which do spurious command completion */
>  	{ "HTS541680J9SA00",	"SB2IC7EP",	ATA_HORKAGE_NONCQ, },
>  	{ "HTS541612J9SA00",	"SBDIC7JP",	ATA_HORKAGE_NONCQ, },
> +	{ "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
>  	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
>  
>  	/* Devices with NCQ limits */
> 

Is that the right ID string? Strange that that one has Hitachi at the 
front and the others don't..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

