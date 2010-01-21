Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187Ab0AUEQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0AUEQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928Ab0AUEQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:16:38 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:52402 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab0AUEQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:16:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tR6RwQupWi9NmTWdqL0ZoNbXWg3IN+yUqjuneM85m8QVcnpWq7APEo3XDnPosifB5u
         MkwHTXLRUihYcGTbsAirwNAN6mlLucGWpLTP4sCL31Gp9GtTA8JC8LTBqpIQNUxSxDh7
         O7/23hIHjRhoKUV4I5SCLvdBosLLTL2DjVhTs=
Message-ID: <4B57D523.2000809@garzik.org>
Date: Wed, 20 Jan 2010 23:16:35 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/64] pata_efar: always program master_data before slave_data
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171555.14623.3131.sendpatchset@localhost>
In-Reply-To: <20100118171555.14623.3131.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 12:15 PM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_efar: always program master_data before slave_data
>
> We may need to set SITRE before programming slave_data.
>
> This makes pata_efar match the behavior of IDE slc90e66 host driver
> and also libata ata_piix one.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/pata_efar.c |    8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)

OK but did not apply to libata-dev.git


