Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbXC2DvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbXC2DvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 23:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXC2DvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 23:51:15 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:41786 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXC2DvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 23:51:14 -0400
Message-ID: <460B36FE.5050301@student.ltu.se>
Date: Thu, 29 Mar 2007 05:48:14 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
CC: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [KJ][PATCH] BIT macro cleanup
References: <20070328033309.GA9597@arun.site>
In-Reply-To: <20070328033309.GA9597@arun.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Milind Arun Choudhary wrote:
> BIT macro cleanup,now in bitops.h
>
> Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
>
> ---
>   
<snip>
> diff --git a/drivers/net/s2io.h b/drivers/net/s2io.h
> index 0de0c65..5aa3be5 100644
> --- a/drivers/net/s2io.h
> +++ b/drivers/net/s2io.h
> @@ -14,6 +14,7 @@
>  #define _S2IO_H
>  
>  #define TBD 0
> +#undef BIT
>  #define BIT(loc)		(0x8000000000000000ULL >> (loc))
>  #define vBIT(val, loc, sz)	(((u64)val) << (64-loc-sz))
>  #define INV(d)  ((d&0xff)<<24) | (((d>>8)&0xff)<<16) | (((d>>16)&0xff)<<8)| ((d>>24)&0xff)
>   
Why not use "LLBIT(63 - loc)" instead?

Richard Knutsson

