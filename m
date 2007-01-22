Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbXAVSst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbXAVSst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 13:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932221AbXAVSss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 13:48:48 -0500
Received: from lucidpixels.com ([66.45.37.187]:51241 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235AbXAVSso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 13:48:44 -0500
Date: Mon, 22 Jan 2007 13:48:44 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Pavel Machek <pavel@ucw.cz>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
In-Reply-To: <20070122133735.GB4493@ucw.cz>
Message-ID: <Pine.LNX.4.64.0701221348020.11525@p34.internal.lan>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
 <20070122133735.GB4493@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Jan 2007, Pavel Machek wrote:

> On Sun 2007-01-21 14:27:34, Justin Piszcz wrote:
> > Why does copying an 18GB on a 74GB raptor raid1 cause the kernel to invoke 
> > the OOM killer and kill all of my processes?
> > 
> > Doing this on a single disk 2.6.19.2 is OK, no issues.  However, this 
> > happens every time!
> > 
> > Anything to try?  Any other output needed?  Can someone shed some light on 
> > this situation?
> 
> Is it highmem-related? Can you try it with mem=256M?
> 
> 							Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

I will give this a try later or tomorrow, I cannot have my machine crash 
at the moment.

Also, the onboard video on the Intel 965 chipset uses 128MB, not sure if 
that has anything to do with it because after the system kill -9's all the 
processes etc, my terminal looks like garbage.

Justin.
