Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892Ab0ARTqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0ARTqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 14:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691Ab0ARTp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 14:45:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:56778 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752654Ab0ARTp7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 14:45:59 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18xEucQkcsxEupOwUkdeFV6FvNLApkTKcbqIT7y5Q
	nPZQ62i6u2kmzx
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] video/matrox: Checkpatch cleanups for matroxfb_crtc2.c
Date: Mon, 18 Jan 2010 20:27:29 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>, Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <201001181934.49519.PeterHuewe@gmx.de> <1263842269.26846.122.camel@Joe-Laptop.home>
In-Reply-To: <1263842269.26846.122.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001182027.29805.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 18 Januar 2010 20:17:49 schrieb Joe Perches:
> On Mon, 2010-01-18 at 19:34 +0100, Peter Hüwe wrote:
> > From: Peter Huewe <peterhuewe@gmx.de>
> > Date: Mon, 18 Jan 2010 19:21:02 +0100
> > This patch fixes all 77 errors reported by checkpatch - no functional
> > change was made. The line over 80 chars warnings were left untouched.
> > diff --git a/drivers/video/matrox/matroxfb_crtc2.c
> > b/drivers/video/matrox/matroxfb_crtc2.c index 78414ba..790ca47 100644
> > --- a/drivers/video/matrox/matroxfb_crtc2.c
> > +++ b/drivers/video/matrox/matroxfb_crtc2.c
> > @@ -42,42 +43,41 @@ static int matroxfb_dh_setcolreg(unsigned regno,
> > unsigned red, unsigned green, blue = CNVT_TOHW(blue,
> > m2info->fbcon.var.blue.length);
> >  	transp = CNVT_TOHW(transp, m2info->fbcon.var.transp.length);
> >
> > -	col = (red << m2info->fbcon.var.red.offset)     |
> > -	      (green << m2info->fbcon.var.green.offset) |
> > -	      (blue << m2info->fbcon.var.blue.offset)   |
> > -	      (transp << m2info->fbcon.var.transp.offset);
> > +	col =	(red << m2info->fbcon.var.red.offset)		|
> > +			(green << m2info->fbcon.var.green.offset)	|
> > +			(blue << m2info->fbcon.var.blue.offset)		|
> > +			(transp << m2info->fbcon.var.transp.offset);
> 
> I think this is not an improvement.
> 

Hi,
the reason behind this change was that spaces and tabs were mixed for 
indention. 



-       col =   (red << m2info->fbcon.var.red.offset)           |
-                       (green << m2info->fbcon.var.green.offset)       |
-                       (blue << m2info->fbcon.var.blue.offset)         |
-                       (transp << m2info->fbcon.var.transp.offset);
+       col = (red << m2info->fbcon.var.red.offset)             |
+               (green << m2info->fbcon.var.green.offset)       |
+               (blue << m2info->fbcon.var.blue.offset)         |
+               (transp << m2info->fbcon.var.transp.offset);

How about this indention? Would this be better?

I'll wait for your response and wrap up the other changes then and resubmit 
it.


Thanks for your comments!

Peter

