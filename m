Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbYJ3TPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbYJ3TPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYJ3TPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:15:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34841 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYJ3TPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:15:20 -0400
Date: Thu, 30 Oct 2008 20:16:30 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] w35und: inline DRIVER_AUTHOR and DRIVER_DESC macros
Message-ID: <20081030191630.GF22185@elf.ucw.cz>
References: <1225383127-16406-1-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225383127-16406-1-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 18:12:01, Pekka Enberg wrote:
> They're used in one place so we can inline them.

Acked-by: Pavel Machek <pavel@suse.cz>

Ok, perhaps I should add myself to the list ;-)...
								Pavel

> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  drivers/staging/winbond/wbusb.c   |    4 ++--
>  drivers/staging/winbond/wbusb_s.h |    3 ---
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
> index 40bb77c..67847c8 100644
> --- a/drivers/staging/winbond/wbusb.c
> +++ b/drivers/staging/winbond/wbusb.c
> @@ -11,8 +11,8 @@
>  #include "wbhal_f.h"
>  #include "wblinux_f.h"
>  
> -MODULE_AUTHOR(DRIVER_AUTHOR);
> -MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_AUTHOR("Original by: Jeff Lee<YY_Lee@issc.com.tw> Adapted to 2.6.x by Costantino Leandro (Rxart Desktop) <le_costantino@pixartargentina.com.ar>");
> +MODULE_DESCRIPTION("IS89C35 802.11bg WLAN USB Driver");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION("0.1");
>  
> diff --git a/drivers/staging/winbond/wbusb_s.h b/drivers/staging/winbond/wbusb_s.h
> index 1aa8ab1..1de9360 100644
> --- a/drivers/staging/winbond/wbusb_s.h
> +++ b/drivers/staging/winbond/wbusb_s.h
> @@ -28,9 +28,6 @@ typedef struct _RW_CONTEXT
>  	void*			pCallBackFunctionParameter;
>  } RW_CONTEXT, *PRW_CONTEXT;
>  
> -#define DRIVER_AUTHOR "Original by: Jeff Lee<YY_Lee@issc.com.tw> Adapted to 2.6.x by Costantino Leandro (Rxart Desktop) <le_costantino@pixartargentina.com.ar>"
> -#define DRIVER_DESC   "IS89C35 802.11bg WLAN USB Driver"
> -
>  typedef struct _WBUSB {
>  	u32	IsUsb20;
>  	struct usb_device *udev;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
