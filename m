Return-Path: <linux-kernel-owner+w=401wt.eu-S1765944AbZDIJ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765944AbZDIJ5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765512AbZDIJzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:55:44 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55793 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765486AbZDIJzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:55:43 -0400
X-Sasl-enc: qhAQofI7z8beXzbb37x3yNLWS3DSwYsNNHlNq3BWqzIs 1239270942
Message-ID: <49DDC61A.8090807@fastmail.fm>
Date: Thu, 09 Apr 2009 10:55:38 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, khali@linux-fr.org,
       ben-linux@fluff.org
Subject: Re: [PATCH 13/56] i2c: Remove void casts
References: <> <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CCs]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
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
>   

