Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbZGIOab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbZGIOab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761233AbZGIOaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:30:22 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:43728 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761350AbZGIOaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:30:20 -0400
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>, tony@atomide.com
Subject: Re: [PATCH 10/44] includecheck fix: arm, mach-omap2/mcbsp.c
References: <1247063308.4382.12.camel@ht.satnam>
	<1247064065.4382.28.camel@ht.satnam>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 09 Jul 2009 07:30:18 -0700
In-Reply-To: <1247064065.4382.28.camel@ht.satnam> (Jaswinder Singh Rajput's message of "Wed\, 08 Jul 2009 20\:11\:05 +0530")
Message-ID: <87tz1mvshx.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> writes:

> fix the following 'make includecheck' warning:
>
>   arch/arm/mach-omap2/mcbsp.c: mach/irqs.h is included more than once.
>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

> ---
>  arch/arm/mach-omap2/mcbsp.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/mcbsp.c b/arch/arm/mach-omap2/mcbsp.c
> index a5c0f04..99b6e15 100644
> --- a/arch/arm/mach-omap2/mcbsp.c
> +++ b/arch/arm/mach-omap2/mcbsp.c
> @@ -19,7 +19,6 @@
>  
>  #include <mach/irqs.h>
>  #include <mach/dma.h>
> -#include <mach/irqs.h>
>  #include <mach/mux.h>
>  #include <mach/cpu.h>
>  #include <mach/mcbsp.h>
> -- 
> 1.6.0.6
