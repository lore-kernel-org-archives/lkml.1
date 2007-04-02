Return-Path: <linux-kernel-owner+w=401wt.eu-S965769AbXDCMn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965769AbXDCMn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 08:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965775AbXDCMn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 08:43:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4220 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965769AbXDCMn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 08:43:27 -0400
Date: Mon, 2 Apr 2007 18:50:15 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       Daniel Jacobowitz <dan@debian.org>
Subject: Re: [PATCH 17/16] Do not reset UTF8 on terminal reset
Message-ID: <20070402185015.GA4628@ucw.cz>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012001130.12316@yvahk01.tjqt.qr> <1175496595.4614.11.camel@daplas> <Pine.LNX.4.61.0704020904460.1245@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704020904460.1245@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Allow for the palette to be exposed and changed via sysfs. A call to
> >> /usr/bin/reset will slurp the new definitions in for the current
> >> console.
> >
> >I like this. The escape sequences to change the palette does not stay
> >permanently.
> 
> As much as you like it, there is a slight problem with it. Linux will
> currently throw virtual consoles out of UTF8 mode when reset is called.
> 
> Also see:
> 	http://lkml.org/lkml/2005/5/17/289
> 	http://lkml.org/lkml/2005/5/17/297
> 
> These posts argue about terminfo being the culprit. But how can terminfo 
> be at fault, when `echo -en "\ec"` triggers it too?
> 
> Since I am in a patch mood, here's my stance/patch, which is compile and 
> run tested and behaves as expected (both with `echo` and `reset`).

Should not reset actually reset terminal? This introduces
bug/unexpected behaviour...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
