Return-Path: <linux-kernel-owner+w=401wt.eu-S965829AbZLHTQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965829AbZLHTQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965800AbZLHTQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:16:15 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:6762 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965819AbZLHTQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:16:14 -0500
Message-ID: <4B1E87DB.5060905@caviumnetworks.com>
Date: Tue, 08 Dec 2009 09:07:39 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Dec 2009 17:07:39.0802 (UTC) FILETIME=[F29F1FA0:01CA7828]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:
> Use the new unreachable() macro instead of for(;;);
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: David Daney <ddaney@caviumnetworks.com>

This looks fine to me.  The comment is somewhat redundant now, but still 
accurate.

Reviewed-by: David Daney <ddaney@caviumnetworks.com>


> ---
>  arch/arm/kernel/traps.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index 3f361a7..25b50c4 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -681,7 +681,7 @@ void __attribute__((noreturn)) __bug(const char *file, int line)
>  	*(int *)0 = 0;
>  
>  	/* Avoid "noreturn function does return" */
> -	for (;;);
> +	unreachable();
>  }
>  EXPORT_SYMBOL(__bug);
>  

