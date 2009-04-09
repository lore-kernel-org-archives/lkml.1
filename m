Return-Path: <linux-kernel-owner+w=401wt.eu-S1761775AbZDIMoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761775AbZDIMoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZDIMnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:43:49 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42456 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZDIMns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:43:48 -0400
Date: Thu, 9 Apr 2009 14:43:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 13/56] i2c: Remove void casts
Message-ID: <20090409144334.4c283ef2@hyperion.delvare>
In-Reply-To: <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jack,

On Wed,  8 Apr 2009 12:21:45 +0100, Jack Stone wrote:
> Remove uneeded void casts
> 
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>

WARNING: Signed-off-by: is the preferred form

> ---
>  drivers/i2c/i2c-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index b6f3a0d..1578645 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -1510,7 +1510,7 @@ struct i2c_adapter* i2c_get_adapter(int id)
>  	struct i2c_adapter *adapter;
>  
>  	mutex_lock(&core_lock);
> -	adapter = (struct i2c_adapter *)idr_find(&i2c_adapter_idr, id);
> +	adapter = idr_find(&i2c_adapter_idr, id);
>  	if (adapter && !try_module_get(adapter->owner))
>  		adapter = NULL;
>  

Applied, thanks.

-- 
Jean Delvare
