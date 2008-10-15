Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYJOH4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYJOH4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 03:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYJOHzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 03:55:45 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:47422 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYJOHzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 03:55:44 -0400
Date: Wed, 15 Oct 2008 09:55:36 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Huang Weiyi <weiyi.huang@gmail.com>
cc: p_gortmaker@yahoo.com, linux-kernel@vger.kernel.org
Subject: Re: m68k: remove duplicated #include
In-Reply-To: <20081015072826.7144.WEIYI.HUANG@gmail.com>
Message-ID: <Pine.LNX.4.64.0810150955070.25759@anakin>
References: <20081015072826.7144.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Huang Weiyi wrote:
> Removed duplicated include <linux/smp_lock.h> in
> arch/m68k/bvme6000/rtc.c.
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

Thanks! Queued for 2.6.29.

BTW, our patch is whitespace-challenged (tab -> space).

> diff --git a/arch/m68k/bvme6000/rtc.c b/arch/m68k/bvme6000/rtc.c
> index e8ac3f7..24d848b 100644
> --- a/arch/m68k/bvme6000/rtc.c
> +++ b/arch/m68k/bvme6000/rtc.c
> @@ -18,7 +18,6 @@
>  #include <linux/poll.h>
>  #include <linux/module.h>
>  #include <linux/mc146818rtc.h> /* For struct rtc_time and ioctls, etc */
> -#include <linux/smp_lock.h>
>  #include <linux/bcd.h>
>  #include <asm/bvme6000hw.h>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
