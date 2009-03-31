Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbZCaHZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbZCaHZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbZCaHZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:25:24 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:16669 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbZCaHZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:25:22 -0400
Date: 31 Mar 2009 09:25:17 +0200
From: krzysztof.h1@poczta.fm
Subject: =?UTF-8?q?Re:_[Linux-fbdev-devel]_[PATCH]_cyblafb:_fix_color_component_length_for_pseudocolor_modes?=
To: Michal Januszewski <spock@gentoo.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, Knut_Petersen@t-online.de
MIME-Version: 1.0
Content-Type: TEXT/plain; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-ORIGINATE-IP: 83.17.101.58
IMPORTANCE: Normal
X-MSMAIL-PRIORITY: Normal
X-PRIORITY: 3
X-Mailer: PSE3
Message-Id: <20090331072517.DC8B37DC90D@f20.poczta.interia.pl>
X-EMID: f6f40acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Januszewski napisa³(a):
> cyblafb incorrectly sets the length of the color fields to 6 bits
> for PSEUDOCOLOR modes, even though 8 bits are always used per pixel.
> Fix this by setting the length to 8.
> 
> Signed-off-by: Michal Januszewski >spock@gentoo.org>
> Cc: Knut Petersen >Knut_Petersen@t-online.de>
> ---
> diff --git a/drivers/video/cyblafb.c b/drivers/video/cyblafb.c
> index 9704b73..8e3a264 100644
> --- a/drivers/video/cyblafb.c
> +++ b/drivers/video/cyblafb.c
> @@ -615,9 +615,9 @@ static int cyblafb_check_var(struct fb_var_screeninfo
> *var,
>  		var->red.offset = 0;
>  		var->green.offset = 0;
>  		var->blue.offset = 0;
> -		var->red.length = 6;
> -		var->green.length = 6;
> -		var->blue.length = 6;
> +		var->red.length = 8;
> +		var->green.length = 8;
> +		var->blue.length = 8;
>  		break;
>  	case 16:
>  		var->red.offset = 11;
> 
> ------------------------------------------------------------------------------
> 

This driver is already removed in the -mm tree (remove-cyblafb-driver.patch).

Regards,
Krzysztof

----------------------------------------------------------------------
Wybierz i wygraj wielkanocna nagrodê!
Sprawdz >>> http://link.interia.pl/f20e8

