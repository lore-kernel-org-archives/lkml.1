Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036Ab0AUEHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab0AUEHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349Ab0AUEHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:07:31 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:58860 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab0AUEH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:07:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uKtC7erOaw2wxFRgu1NKYKVHL+XOPBjrvTvIooglyLjASsswkJi/4krRllx88I48A8
         sxGO/FelbIvai0QOFPTCaLfbc229OxKvqen/Ndifu3CMNIOArH39tH60WjuTxOfyYEUz
         53FG1Lz/hrblZ+eqJtaO37a6BYKw4q5bpmx+Q=
Message-ID: <4B57D2FE.9050702@garzik.org>
Date: Wed, 20 Jan 2010 23:07:26 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/64] pata_atiixp: add locking for parallel scanning
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171437.14623.12197.sendpatchset@localhost>
In-Reply-To: <20100118171437.14623.12197.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 12:14 PM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_atiixp: add locking for parallel scanning
>
> This is similar change as commit 60c3be3 for ata_piix host driver
> and while pata_atiixp doesn't enable parallel scan yet the race
> could probably also be triggered by requesting re-scanning of both
> ports at the same time using SCSI sysfs interface.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/pata_atiixp.c |   14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)

did not apply to libata-dev.git#upstream, so skipped this and patch #7


