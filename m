Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbYETGPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbYETGPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 02:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbYETGPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 02:15:36 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1943 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754131AbYETGPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 02:15:35 -0400
Message-ID: <48326718.90504@myri.com>
Date: Tue, 20 May 2008 07:52:24 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Gallatin <gallatin@myri.com>, jgarzik@pobox.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make myri10ge_get_firmware_capabilities() static
References: <20080519215300.GC17716@cs181133002.pp.htv.fi>
In-Reply-To: <20080519215300.GC17716@cs181133002.pp.htv.fi>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the needlessly global 
> myri10ge_get_firmware_capabilities() static.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>   
Acked-by: Brice Goglin <brice@myri.com>

> ---
> 0442d0c2cb767d312f5264cc226a1595c47f3dbf diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
> index c91b12e..36be6ef 100644
> --- a/drivers/net/myri10ge/myri10ge.c
> +++ b/drivers/net/myri10ge/myri10ge.c
> @@ -631,7 +631,7 @@ static int myri10ge_adopt_running_firmware(struct myri10ge_priv *mgp)
>  	return status;
>  }
>  
> -int myri10ge_get_firmware_capabilities(struct myri10ge_priv *mgp)
> +static int myri10ge_get_firmware_capabilities(struct myri10ge_priv *mgp)
>  {
>  	struct myri10ge_cmd cmd;
>  	int status;
>
>   

