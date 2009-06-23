Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbZFWOUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbZFWOUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZFWOT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:19:56 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:51024 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755344AbZFWOTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:19:55 -0400
Date: Tue, 23 Jun 2009 16:13:50 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, avictor.za@gmail.com
Subject: Re: [RFC PATCH] atmel_lcdfb Kconfig: remove long dependency line
Message-ID: <20090623141350.GI23512@game.jcrosoft.org>
References: <4A40D695.5000302@atmel.com>
 <1245767456-6434-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245767456-6434-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 16467130563552193388
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> +config ARCH_ATMEL_HAS_FB
> +	bool
> +	depends on FB
as you use it just under with the FB condition too
I think you can avoid this depend here
> +	default n
> +
>  config FB_ATMEL
>  	tristate "AT91/AT32 LCD Controller support"
> -	depends on FB && (ARCH_AT91SAM9261 || ARCH_AT91SAM9G10 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45 || ARCH_AT91CAP9 || AVR32)
> +	depends on FB && ARCH_ATMEL_HAS_FB
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT

Best Regards,
J.
