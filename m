Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXCZMgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXCZMgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbXCZMgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:36:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4783 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752463AbXCZMgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:36:14 -0400
Date: Mon, 26 Mar 2007 12:35:52 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Marcus Better <marcus@better.se>
Cc: Adrian Bunk <bunk@stusta.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Message-ID: <20070326123552.GB11288@ucw.cz>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323185022.GQ752@stusta.de> <200703261200.25587.marcus@better.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703261200.25587.marcus@better.se>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Subject    : ThinkPad R60: suspend to disk broken
> > References : http://lkml.org/lkml/2007/3/23/74
> > Submitter  : Marcus Better <marcus@better.se>
> > Status     : submitter tries to bisect
> 
> I just tried -rc5. Now suspend to disk seems to work. I think the XFS 
> workqueue patch fixed this.
> 
> It can also suspend to RAM, but resume is worse. The first time around it 
> resumed but corrupted the vesafb console (greenish blinking character cells), 
> something that used to work before. But the system responded to input, so I 
> suspended to RAM again. This time the resume failed, it hung after 
> printing "Linux!" in yellow at the top of the screen. (Seems to be some 
> artifact, I have seen it before even with working suspend.)

Yellow Linux! is my debugging trick. It should be there, but it should
also disapear quickly.

Try vga=0 ... text console seems to work for you.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
