Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbXCNTr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbXCNTr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932501AbXCNTr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:47:27 -0400
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:48253 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbXCNTr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:47:26 -0400
Date: Wed, 14 Mar 2007 20:45:50 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/13] rtc-cmos needs RTC_ALWAYS_BCD known
In-Reply-To: <E1HRPbK-0003Gn-Of@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0703142045270.5429@anakin>
References: <E1HRPbK-0003Gn-Of@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  include/asm-m68k/mc146818rtc.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-m68k/mc146818rtc.h b/include/asm-m68k/mc146818rtc.h
> index 11fe12d..9f70a01 100644
> --- a/include/asm-m68k/mc146818rtc.h
> +++ b/include/asm-m68k/mc146818rtc.h
> @@ -11,6 +11,7 @@
>  #include <asm/atarihw.h>
>  
>  #define RTC_PORT(x)	(TT_RTC_BAS + 2*(x))
> +#define RTC_ALWAYS_BCD	0
>  
>  #define CMOS_READ(addr) ({ \
>  atari_outb_p((addr),RTC_PORT(0)); \

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
