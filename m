Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbXAVSrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbXAVSrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 13:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932221AbXAVSrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 13:47:19 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2563 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932224AbXAVSrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 13:47:18 -0500
Date: Mon, 22 Jan 2007 13:37:35 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like 2.16.19.2
Message-ID: <20070122133735.GB4493@ucw.cz>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-01-21 14:27:34, Justin Piszcz wrote:
> Why does copying an 18GB on a 74GB raptor raid1 cause the kernel to invoke 
> the OOM killer and kill all of my processes?
> 
> Doing this on a single disk 2.6.19.2 is OK, no issues.  However, this 
> happens every time!
> 
> Anything to try?  Any other output needed?  Can someone shed some light on 
> this situation?

Is it highmem-related? Can you try it with mem=256M?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
