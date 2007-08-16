Return-Path: <linux-kernel-owner+w=401wt.eu-S1764413AbXHPHRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764413AbXHPHRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbXHPHRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:17:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:10023 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbXHPHRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=QYXWyr3geBsqtEl4QDFAFd349AM/aYcRJJ9Jrz4zJcw0HVeTrbg3m/xpXNtztdd3zfkZb6pABz5iG/I8432OAiQrnppwqo5gC56PmeNl6Tf3MNWk0lTkWvrtEebbiL23JfmXrvNiGl/TjB7Zucj2/DB/GPdVPvLg/gOaoWpnrA4=
Message-ID: <46C3FA03.9060304@gmail.com>
Date: Thu, 16 Aug 2007 11:17:23 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] dvb/bt8xx: "extern inline" ->
 "static inline"
References: <20070814212530.GS18945@stusta.de>
In-Reply-To: <20070814212530.GS18945@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> "extern inline" will have different semantics with gcc 4.3.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 6ffbe5b19606cd8756be4d04e0902de69e447c85 
> diff --git a/drivers/media/dvb/bt8xx/bt878.h b/drivers/media/dvb/bt8xx/bt878.h
> index f685bc1..1c8e336 100644
> --- a/drivers/media/dvb/bt8xx/bt878.h
> +++ b/drivers/media/dvb/bt8xx/bt878.h
> @@ -149,7 +149,7 @@ void bt878_start(struct bt878 *bt, u32 controlreg, u32 op_sync_orin,
>  void bt878_stop(struct bt878 *bt);
>  
>  #if defined(__powerpc__)	/* big-endian */
> -extern __inline__ void io_st_le32(volatile unsigned __iomem *addr, unsigned val)
> +static inline void io_st_le32(volatile unsigned __iomem *addr, unsigned val)
>  {
>  	__asm__ __volatile__("stwbrx %1,0,%2":"=m"(*addr):"r"(val),
>  			     "r"(addr));
> 
> 

Signed-off-by: Manu Abraham <manu@linuxtv.org>

