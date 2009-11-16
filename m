Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbZKPUDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbZKPUDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 15:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZKPUDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 15:03:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:50239 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbZKPUDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 15:03:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rYFKaZVFlZqEzoF65ihnkqBcRglWdKvmEq+jEfImu6Hz2FYnQRImnbp8m3RxR0G7QO
         pyhqK819MuWgeSo3MZ/l0iJKYTlRmwEOG/H25HkdyGlkWEpcqtG7yjMNtEeolI/klZ88
         4ekHUOUuej/4W6Q1GoI3AUkC1MGfkmeZiIroI=
MIME-Version: 1.0
In-Reply-To: <4b016848.3j3kclbqZ4ylyZGU%Larry.Finger@lwfinger.net>
References: <4b016848.3j3kclbqZ4ylyZGU%Larry.Finger@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 16 Nov 2009 21:02:52 +0100
Message-ID: <69e28c910911161202w5255bff5ydb7fc665b3320bda@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8187se: Rename staging driver to avoid name 
	conflict with mainline driver
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 3:57 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Now that active development has begun on a mainline version of
> a driver for the RTL8187SE that should be called rtl8187se, there
> is a conflict with the driver in staging with the same name.
>
> To solve the conflict, rename the driver in staging to rtl8187se_stage.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> Index: wireless-testing/drivers/staging/Makefile
> ===================================================================
> --- wireless-testing.orig/drivers/staging/Makefile
> +++ wireless-testing/drivers/staging/Makefile
> @@ -20,7 +20,7 @@ obj-$(CONFIG_COMEDI)          += comedi/
>  obj-$(CONFIG_ASUS_OLED)                += asus_oled/
>  obj-$(CONFIG_PANEL)            += panel/
>  obj-$(CONFIG_ALTERA_PCIE_CHDMA)        += altpciechdma/
> -obj-$(CONFIG_RTL8187SE)                += rtl8187se/
> +obj-$(CONFIG_RTL8187SE_STAGE)  += rtl8187se/
>  obj-$(CONFIG_RTL8192SU)                += rtl8192su/
>  obj-$(CONFIG_RTL8192E)         += rtl8192e/
>  obj-$(CONFIG_INPUT_MIMIO)      += mimio/
> Index: wireless-testing/drivers/staging/rtl8187se/Kconfig
> ===================================================================
> --- wireless-testing.orig/drivers/staging/rtl8187se/Kconfig
> +++ wireless-testing/drivers/staging/rtl8187se/Kconfig
> @@ -1,4 +1,4 @@
> -config RTL8187SE
> +config RTL8187SE_STAGE
>        tristate "RealTek RTL8187SE Wireless LAN NIC driver"
>        depends on PCI && WLAN
>        select WIRELESS_EXT
> Index: wireless-testing/drivers/staging/rtl8187se/Makefile
> ===================================================================
> --- wireless-testing.orig/drivers/staging/rtl8187se/Makefile
> +++ wireless-testing/drivers/staging/rtl8187se/Makefile
> @@ -16,7 +16,7 @@ EXTRA_CFLAGS += -DENABLE_LPS
>
>  #EXTRA_CFLAGS += -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
>
> -rtl8187se-objs :=                      \
> +rtl8187se_stage-objs :=                        \
>                r8180_core.o            \
>                r8180_93cx6.o           \
>                r8180_wx.o              \
> @@ -35,5 +35,5 @@ rtl8187se-objs :=                     \
>                ieee80211/ieee80211_crypt_ccmp.o        \
>                ieee80211/ieee80211_crypt_wep.o
>
> -obj-$(CONFIG_RTL8187SE)        += rtl8187se.o
> +obj-$(CONFIG_RTL8187SE_STAGE)  += rtl8187se_stage.o

Please make this r8187se.o, to be consistent with the other
r8180-sa2400 derivative drivers.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
