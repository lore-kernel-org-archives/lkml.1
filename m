Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbXE0VUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbXE0VUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757367AbXE0VUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:20:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4010 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756738AbXE0VUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:20:14 -0400
Date: Sun, 27 May 2007 21:20:03 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Bill Davidsen <davidsen@tmr.com>
Cc: David Greaves <david@dgreaves.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
Message-ID: <20070527212002.GI3989@ucw.cz>
References: <4658B7DD.3060309@tmr.com> <4659442E.2060307@dgreaves.com> <4659834E.4070506@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4659834E.4070506@tmr.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >It is very dangerous to attempt a resume with a 
> >different kernel than the one
> >that has gone to sleep.
> >Different kernels may be compiled with different 
> >options that affect where or
> >how in-memory structures are saved.
> >
> If the mainline resume is depending on that no wonder 
> resume is so fragile. User action can change order of 
> module loads, kmalloc calls move allocated structures, 
> etc. Counting on anything to be locked in place seems 
> naive.

Look at code before spreading FUD. (suspend and suspend2 are same in
this matter).

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
