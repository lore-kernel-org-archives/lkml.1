Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbZCaHYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbZCaHYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZCaHX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:23:59 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:14553 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbZCaHX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:23:58 -0400
Date: 31 Mar 2009 09:23:51 +0200
From: krzysztof.h1@poczta.fm
Subject: =?UTF-8?q?Re:_[Linux-fbdev-devel]_[PATCH]_cirrusfb:_fix_color_component_length_for_pseudocolor_modes?=
To: Michal Januszewski <spock@gentoo.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: TEXT/plain; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-ORIGINATE-IP: 83.17.101.58
IMPORTANCE: Normal
X-MSMAIL-PRIORITY: Normal
X-PRIORITY: 3
X-Mailer: PSE3
Message-Id: <20090331072351.5028D7DC90B@f20.poczta.interia.pl>
X-EMID: 30f40acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Januszewski napisa³(a):
> cirrusfb incorrectly sets the length of the color fields to 6 bits
> for PSEUDOCOLOR modes, even though 8 bits are always used per pixel.
> Fix this by setting the length to 8.
> 
> Signed-off-by: Michal Januszewski >spock@gentoo.org>
> ---
> diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
> index a2aa6dd..2dfe0e7 100644
> --- a/drivers/video/cirrusfb.c
> +++ b/drivers/video/cirrusfb.c
> @@ -550,7 +550,7 @@ static int cirrusfb_check_var(struct fb_var_screeninfo
> *var,
>  
>  	case 8:
>  		var->red.offset = 0;
> -		var->red.length = 6;
> +		var->red.length = 8;
>  		var->green = var->red;
>  		var->blue = var->red;
>  		break;
> 

This is already fixed in the -mm tree (cirrusfb-check_var-improvements.patch).

Regards,
Krzysztof

----------------------------------------------------------------------
Widziales zajaca? Zgubil nagrody!
Sprawdz >>> http://link.interia.pl/f20e9

