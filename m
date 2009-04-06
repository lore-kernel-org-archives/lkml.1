Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbZDFWka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbZDFWka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZDFWkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:40:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42292 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbZDFWkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:40:18 -0400
Date: Mon, 6 Apr 2009 19:39:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH resend] PWC: fix build error when CONFIG_INPUT=m
Message-ID: <20090406193940.36248080@pedra.chehab.org>
In-Reply-To: <20090406145931.c1c843ed.randy.dunlap@oracle.com>
References: <20090406145931.c1c843ed.randy.dunlap@oracle.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

Next time, could you please c/c linux-media@vger.kernel.org? I'm relying on
linux-media project at Patchwork for helping to not forget to patches.

Thanks,
Mauro.

On Mon, 6 Apr 2009 14:59:31 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build errors when USB_PWC=y and INPUT=m.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/media/video/pwc/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- mmotm-2009-0214-0049.orig/drivers/media/video/pwc/Kconfig
> +++ mmotm-2009-0214-0049/drivers/media/video/pwc/Kconfig
> @@ -39,7 +39,7 @@ config USB_PWC_DEBUG
>  config USB_PWC_INPUT_EVDEV
>  	bool "USB Philips Cameras input events device support"
>  	default y
> -	depends on USB_PWC && INPUT
> +	depends on USB_PWC=INPUT || INPUT=y
>  	---help---
>  	  This option makes USB Philips cameras register the snapshot button as
>  	  an input device to report button events.


-- 

Cheers,
Mauro
