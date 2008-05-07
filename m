Return-Path: <linux-kernel-owner+w=401wt.eu-S1762931AbYEGQvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762931AbYEGQvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYEGQuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:50:18 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:27975 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbYEGQuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:50:13 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 May 2008 12:50:13 EDT
Date: Wed, 7 May 2008 18:50:14 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: <JosephChan@via.com.tw>
Cc: <akpm@linux-foundation.org>, <geert@linux-m68k.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 7/9] viafb: VIA Frame Buffer Device
 Driver
Message-Id: <20080507185014.d15da044.krzysztof.h1@poczta.fm>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F6775A@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F6775A@exchtp03.taipei.via.com.tw>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 7ce2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008 19:09:44 +0800
<JosephChan@via.com.tw> wrote:

> Signed-off-by: Joseph Chan <josephchan@via.com.tw>
> 
> diff -Nur a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
> --- a/drivers/video/via/viafbdev.h	1969-12-31 19:00:00.000000000 -0500
> +++ b/drivers/video/via/viafbdev.h	2008-04-29 04:27:46.000000000 -0400
> @@ -0,0 +1,114 @@

(...)
> +
> +struct viafb_par {
> +	struct fb_var_screeninfo var;
> +	int bpp;
> +	int hres;
> +	int vres;
> +	int linelength;
> +	int vclk;		/*in MHz */
> +
> +	int vtotal;
> +	int vdispend;
> +	int vsyncstart;
> +	int vsyncend;
> +	int vblankstart;
> +	int vblankend;
> +
> +	int htotal;
> +	int hdispend;
> +	int hsyncstart;
> +	int hsyncend;
> +	int hblankstart;
> +	int hblankend;
> +
> +	int accel;		/* Acceleration Flags */

A random pick of "accel", "hblankstart" and "hblankend" shows that they are only set and never checked. Try to remove all unused fields here.

Regards,
Krzysztof

----------------------------------------------------------------------
Lepszy niz zakladki. 	
Kliknij >>> http://link.interia.pl/f1db1

