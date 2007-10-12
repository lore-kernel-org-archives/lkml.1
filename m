Return-Path: <linux-kernel-owner+w=401wt.eu-S934726AbXJLXTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726AbXJLXTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934553AbXJLXOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 19:14:18 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41865 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934024AbXJLXON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 19:14:13 -0400
Date: Fri, 12 Oct 2007 16:13:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sebastian Siewior <sebastian@breakpoint.cc>
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH] [mmc] fix compile without LED Triggers
Message-Id: <20071012161300.ff4f6e0b.randy.dunlap@oracle.com>
In-Reply-To: <E1IgSxy-0003pj-Ik@Chamillionaire.breakpoint.cc>
References: <E1IgSxy-0003pj-Ik@Chamillionaire.breakpoint.cc>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007 00:25:15 +0200 Sebastian Siewior wrote:

> drivers/mmc/core/host.c: In function 'mmc_remove_host':
> drivers/mmc/core/host.c:146: error: implicit declaration of function 'led_trigger_unregister'
> drivers/mmc/core/host.c:146: error: 'struct mmc_host' has no member named 'led'
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> ---
>  include/linux/leds.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index dc1178f..24c4830 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -98,6 +98,7 @@ extern void led_trigger_event(struct led_trigger *trigger,
>  #define DEFINE_LED_TRIGGER_GLOBAL(x)
>  #define led_trigger_register_simple(x, y) do {} while(0)
>  #define led_trigger_unregister_simple(x) do {} while(0)
> +#define led_trigger_unregister(x) do {} while(0)
>  #define led_trigger_event(x, y) do {} while(0)
>  
>  #endif

or this patch that was posted earlier:
http://lkml.org/lkml/2007/10/12/380

---
~Randy
