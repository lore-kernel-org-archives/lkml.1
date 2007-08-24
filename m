Return-Path: <linux-kernel-owner+w=401wt.eu-S965010AbXHXCj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010AbXHXCj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 22:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933664AbXHXCjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 22:39:16 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:64464 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933503AbXHXCjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 22:39:15 -0400
Message-ID: <46CE43FC.9040104@student.ltu.se>
Date: Fri, 24 Aug 2007 04:35:40 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ram.vepa@neterion.com, santosh.rastapur@neterion.com,
       sivakumar.subramani@neterion.com, sreenivasa.honnur@neterion.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 4/9] s2io, rename BIT macro
References: <27692164102679012429@wsc.cz>
In-Reply-To: <27692164102679012429@wsc.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> s2io, rename BIT macro
>
> BIT macro will be global definiton of (1<<x)
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>
> ---
>   
[snip]
>  			cnt++;
>  			if (cnt == 5)
> diff --git a/drivers/net/s2io.h b/drivers/net/s2io.h
> index 92983ee..448f899 100644
> --- a/drivers/net/s2io.h
> +++ b/drivers/net/s2io.h
> @@ -14,7 +14,7 @@
>  #define _S2IO_H
>  
>  #define TBD 0
> -#define BIT(loc)		(0x8000000000000000ULL >> (loc))
> +#define s2BIT(loc)		(0x8000000000000000ULL >> (loc))
>  #define vBIT(val, loc, sz)	(((u64)val) << (64-loc-sz))
>  #define INV(d)  ((d&0xff)<<24) | (((d>>8)&0xff)<<16) | (((d>>16)&0xff)<<8)| ((d>>24)&0xff)
>  
>   
Sorry for the late response, but would it not be better/easier to use 
BIT() instead (or a global #define LLBIT(nr)  (1ULL << (nr))) and just 
recalculate the values?

Richard Knutsson

