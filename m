Return-Path: <linux-kernel-owner+w=401wt.eu-S1763185AbYA1XDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763185AbYA1XDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761844AbYA1XCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:02:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:44526 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762302AbYA1XCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:02:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RGg5RcPGVS8wba66j23VLrRjuo7DJ1pypy4tk1EyG6PoktrbLMpzT3ekauhjzxwvBBanpjEDi4fK8I3zSnkR/KbIBP/7453oIiLTE8drkNHxNmBTiM6w8gw9FqvClucl9GLtj/xplF0xylNgZJLgyVMBjqjDOoeYfyEYWRxNxRY=
Message-ID: <479E5F04.3000009@gmail.com>
Date: Tue, 29 Jan 2008 08:02:28 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] ata_piix.c: make piix_merge_scr() static
References: <20080128221019.GN8767@does.not.exist>
In-Reply-To: <20080128221019.GN8767@does.not.exist>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> piix_merge_scr() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> f272ad2ac4274a59f0b43cfd65488c51855132d4 
> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index a65c8ae..1a5c3bf 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -1068,7 +1068,7 @@ static void piix_sidpr_write(struct ata_device *dev, unsigned int reg, u32 val)
>  	iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
>  }
>  
> -u32 piix_merge_scr(u32 val0, u32 val1, const int * const *merge_tbl)
> +static u32 piix_merge_scr(u32 val0, u32 val1, const int * const *merge_tbl)
>  {
>  	u32 val = 0;
>  	int i, mi;

Ah.. right.  Thanks.  I somehow forgot static in front of it.

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
