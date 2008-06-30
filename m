Return-Path: <linux-kernel-owner+w=401wt.eu-S1760903AbYF3KrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbYF3KrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYF3KrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:47:09 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58608 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbYF3KrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:47:08 -0400
Date: Mon, 30 Jun 2008 12:47:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: JosephChan@via.com.tw
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, geert@linux-m68k.org
Subject: Re: [PATCH 9/13] viafb: Makefile, share.h
Message-ID: <20080630104753.GA16040@uranus.ravnborg.org>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E786A@exchtp03.taipei.via.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E786A@exchtp03.taipei.via.com.tw>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 03:38:52PM +0800, JosephChan@via.com.tw wrote:
> Makefile for drivers/video/via/ 
> share.h: shared macro for viafb
> 
> 
> Signed-off-by: Joseph Chan <josephchan@via.com.tw>
> 
> diff -Nur a/drivers/video/via/Makefile b/drivers/video/via/Makefile
> --- a/drivers/video/via/Makefile	1970-01-01 08:00:00.000000000 +0800
> +++ b/drivers/video/via/Makefile	2008-06-30 08:53:33.000000000 +0800
> @@ -0,0 +1,9 @@
> +#
> +# Makefile for the VIA framebuffer driver (for Linux Kernel 2.6)
> +#
> +                                                                                
> +obj-$(CONFIG_FB_VIA) += viafb.o
> +
> +viafb-y	:=viafbdev.o hw.o iface.o  via_i2c.o dvi.o lcd.o ioctl.o accel.o via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o
> +
> +viafb-objs	:=	$(viafb-y)

This assignmnet is not needed - please drop it.
kbuild already understands <modulename>-y

	Sam
