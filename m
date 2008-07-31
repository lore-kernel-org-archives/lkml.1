Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYGaFpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYGaFpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 01:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYGaFpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 01:45:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52592 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYGaFpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 01:45:31 -0400
Message-ID: <48915177.3060703@garzik.org>
Date: Thu, 31 Jul 2008 01:45:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chuck Short <zulcss@ubuntu.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/7] ata: blacklist FUJITSU MHW2160BH PL
References: <E1KKl4I-00068E-Ob@swissweb.swissdisk.com>
In-Reply-To: <E1KKl4I-00068E-Ob@swissweb.swissdisk.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
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

This is outdated -- spurious completion code is long gone


