Return-Path: <linux-kernel-owner+w=401wt.eu-S933944AbXDBGuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944AbXDBGuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933946AbXDBGuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:50:01 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:31866 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933944AbXDBGuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ggcrDZFg+G0XqflYf/IdLyZhJgPbWaCi4BEz7CNKcLX6SjBg5JvM0fbPm9vA/zYXKRAYj/k6SEwB0sQxD/eSUkgtX2rJpDnJ+nshQG3IyHEZOh48LN95mkEHzRfror5wbj8cLw3zHjXTVZ0Zoh3ELbvXxezYhCf1+4O6kagN6FQ=
Subject: Re: [PATCH 2/16] vt-pure-colors.diff
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0704012002330.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704012002330.12316@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 14:49:52 +0800
Message-Id: <1175496592.4614.9.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-01 at 20:14 +0200, Jan Engelhardt wrote:
> Have the Linux kernel set a new VGA palette for the first 16 colors.
> The new values reduce the saturation (white component) and therefore
> increase contrast.
> 
> Already posted once: http://lkml.org/lkml/2006/1/15/149
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
>  vt.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6.21-rc5/drivers/char/vt.c
> ===================================================================
> --- linux-2.6.21-rc5.orig/drivers/char/vt.c
> +++ linux-2.6.21-rc5/drivers/char/vt.c
> @@ -927,12 +927,12 @@ unsigned char color_table[] = { 0, 4, 2,
>  				       8,12,10,14, 9,13,11,15 };
>  
>  /* the default colour table, for VGA+ colour systems */
> -int default_red[] = {0x00,0xaa,0x00,0xaa,0x00,0xaa,0x00,0xaa,
> -    0x55,0xff,0x55,0xff,0x55,0xff,0x55,0xff};
> -int default_grn[] = {0x00,0x00,0xaa,0x55,0x00,0x00,0xaa,0xaa,
> -    0x55,0x55,0xff,0xff,0x55,0x55,0xff,0xff};
> -int default_blu[] = {0x00,0x00,0x00,0x00,0xaa,0xaa,0xaa,0xaa,
> -    0x55,0x55,0x55,0x55,0xff,0xff,0xff,0xff};
> +int default_red[] =
> +{0x00,0xaa,0x00,0xaa,0x00,0xaa,0x00,0xaa,0x55,0xff,0x00,0xff,0x00,0xff,0x00,0xff};
> +int default_grn[] =
> +{0x00,0x00,0xaa,0x55,0x00,0x00,0xaa,0xaa,0x55,0x00,0xff,0xff,0x00,0x00,0xff,0xff};
> +int default_blu[] =
> +{0x00,0x00,0x00,0x00,0x90,0xaa,0xaa,0xaa,0x55,0x00,0x00,0x00,0xff,0xff,0xff,0xff};
>  

Not too sure about this, the default palette is based on ANSI/ECMA
standards (at least for the first 8 colors). Also, this will have subtle
effects on the 16-color logo. Since your first patch already allows us
to change the palette, let's leave the default alone.

 
Tony


