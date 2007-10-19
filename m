Return-Path: <linux-kernel-owner+w=401wt.eu-S1762618AbXJSMYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762618AbXJSMYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbXJSMYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:24:06 -0400
Received: from emulex.emulex.com ([138.239.112.1]:36861 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbXJSMYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:24:04 -0400
Message-ID: <4718A1C0.3000501@emulex.com>
Date: Fri, 19 Oct 2007 08:23:28 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] scsi/lpfc/lpfc_debugfs.c: fix typo
References: <20071018105237.GL3778@stusta.de>
In-Reply-To: <20071018105237.GL3778@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2007 12:23:28.0582 (UTC) FILETIME=[DAAEAE60:01C8124A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

-- james s

Adrian Bunk wrote:
> This patch fixes a typo introduced by
> commit bbfbbbc1182f8b44c8cc4c99f4a3f3a512149022.
> 
> It wasn't a compile error since CONFIG_LPFC_DEBUG_FS is not (yet?) 
> available as an option.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 74e14a2a4ed066aa8fedd557a6768fdfec5eb883 
> diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
> index 149fdd2..d6a98bc 100644
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c
> @@ -901,7 +901,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
>  		}
>  	}
>  
> -	vport->disc_trc = kmzlloc(
> +	vport->disc_trc = kzalloc(
>  		(sizeof(struct lpfc_debugfs_trc) * lpfc_debugfs_max_disc_trc),
>  		GFP_KERNEL);
>  
> 
> 
