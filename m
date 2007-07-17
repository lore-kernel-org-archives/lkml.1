Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbXGQMLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbXGQMLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbXGQMLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:11:30 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2137 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbXGQML3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:11:29 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2007 08:11:28 EDT
Message-ID: <4194.194.196.35.3.1184673826.squirrel@webmail.xs4all.nl>
In-Reply-To: <20070717114741.GC25083@localhost.sw.ru>
References: <20070717114741.GC25083@localhost.sw.ru>
Date: Tue, 17 Jul 2007 14:03:46 +0200 (CEST)
Subject: Re: [PATCH] ivtv: don't recompile needlessly
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Alexey Dobriyan" <adobriyan@sw.ru>
Cc: akpm@osdl.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, hverkuil@xs4all.nl
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Driver prints 3l33t banner including kernel version.
> Could we _please_ never do this in future.

Thanks for reporting this. This was a leftover from when the driver was
standalone. I've merged this patch in my repository and will push it
upstream.

Regards,

        Hans

>
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
>
>  drivers/media/video/ivtv/ivtv-driver.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> --- a/drivers/media/video/ivtv/ivtv-driver.c
> +++ b/drivers/media/video/ivtv/ivtv-driver.c
> @@ -56,7 +56,6 @@
>  #include "ivtv-gpio.h"
>  #include "ivtv-yuv.h"
>
> -#include <linux/vermagic.h>
>  #include <media/tveeprom.h>
>  #include <media/v4l2-chip-ident.h>
>
> @@ -1315,7 +1314,7 @@ static struct pci_driver ivtv_pci_driver = {
>  static int module_start(void)
>  {
>  	printk(KERN_INFO "ivtv:  ==================== START INIT IVTV
> ====================\n");
> -	printk(KERN_INFO "ivtv:  version %s (" VERMAGIC_STRING ") loading\n",
> IVTV_VERSION);
> +	printk(KERN_INFO "ivtv:  version %s loading\n", IVTV_VERSION);
>
>  	memset(ivtv_cards, 0, sizeof(ivtv_cards));
>
>
>


