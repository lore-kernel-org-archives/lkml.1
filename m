Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab0CAUM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 15:12:29 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:56213 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0CAUM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 15:12:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uko3Tq1CzouCMOXRlf0v4xylJForInns4tb5GhgXNtbE1An+jA7F5/lC8W25SdtG9o
         uDKkFsEuDp1AxDIANh5INFQsOqDS9hO/+wK3ECvt4Br3cDsCGwwS2zm57S1xsC4bSE0l
         +AIbos0GrxkwLxQdHj0WVKPMaVEs18kAaT4wg=
Message-ID: <4B8C1F9E.8040703@garzik.org>
Date: Mon, 01 Mar 2010 15:12:14 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: jeff@garzik.org.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/5] Subject: [PATCH] pata_efar: add locking for parallel
 scanning
References: <20100217131532.16884.21696.stgit@localhost.localdomain> <20100217131556.16884.47082.stgit@localhost.localdomain>
In-Reply-To: <20100217131556.16884.47082.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 08:16 AM, Alan Cox wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>
> Add clearing of UDMA enable bit also for PIO modes and then add
> an extra locking for parallel scanning.
>
> This is similar change as commit 60c3be3 for ata_piix host driver
> and while pata_efar doesn't enable parallel scan yet the race could
> probably also be triggered by requesting re-scanning of both ports
> at the same time using SCSI sysfs interface.
>
> [Ported to current kernel without other patch dependancies by
>   Alan Cox]
>
> Original is
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>
> This one is
> Signed-off-by: Alan Cox<alan@linux.intel.com>
> ---
>
>   drivers/ata/pata_efar.c |   15 +++++++++++++++
>   1 files changed, 15 insertions(+), 0 deletions(-)

applied 2-5


