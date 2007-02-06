Return-Path: <linux-kernel-owner+w=401wt.eu-S965383AbXBFTdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965383AbXBFTdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965381AbXBFTdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:33:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53493 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965383AbXBFTdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:33:09 -0500
Date: Tue, 6 Feb 2007 19:33:05 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Richard Purdie <rpurdie@rpsys.net>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Linux-Input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: Re: [PATCH] input: Schedule removal of compaq touchscreen emulation
 (tsdev.c)
In-Reply-To: <1170780159.5826.71.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702061930280.9224@pentafluge.infradead.org>
References: <1170780159.5826.71.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


My old driver. Yes please kill it.

Acked-By: James Simmons <jsimmons@infradead.org>

On Tue, 6 Feb 2007, Richard Purdie wrote:

> Schedule removal of Compaq touchscreen emulation (drivers/input/tsdev.c)
> 
> Its old, was obsolete when it was written by the authors own admission
> and much better userspace solutions like tslib now exist. The name is
> also confusing.
> 
> Signed-off-by: Richard Purdie <rpurdie@rpsys.net> 
> 
>  Documentation/feature-removal-schedule.txt |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> Index: linux/Documentation/feature-removal-schedule.txt
> ===================================================================
> --- linux.orig/Documentation/feature-removal-schedule.txt	2007-02-06 09:40:43.000000000 +0000
> +++ linux/Documentation/feature-removal-schedule.txt	2007-02-06 11:36:31.000000000 +0000
> @@ -325,3 +325,17 @@ Why:	Unmaintained for years, superceded 
>  Who:	Jeff Garzik <jeff@garzik.org>
>  
>  ---------------------------
> +
> +What:   Compaq touchscreen device emulation
> +When:   Oct 2007
> +Files:  drivers/input/tsdev.c
> +Why:    The code says it was obsolete when it was written in 2001.
> +        tslib is a userspace library which does anything tsdev can do and
> +        much more besides in userspace where this code belongs. There is no
> +        longer any need for tsdev and applications should have converted to
> +        use tslib by now.
> +        The name "tsdev" is also extremely confusing and lots of people have
> +        it loaded when they don't need/use it.
> +Who:    Richard Purdie <rpurdie@rpsys.net>
> +
> +---------------------------
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
