Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbXGUJ2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbXGUJ2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 05:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760148AbXGUJ2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 05:28:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51950 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756444AbXGUJ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 05:28:09 -0400
Date: Sat, 21 Jul 2007 11:28:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: oleg@tv-sign.ru, rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM
Message-ID: <20070721092819.GA1902@elf.ucw.cz>
References: <20070714212102.GA214@tv-sign.ru> <E1IA3oR-0002wg-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IA3oR-0002wg-00@dorka.pomaz.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-07-15 15:06:59, Miklos Szeredi wrote:
> > > SIGKILL won't work on a stopped task.  Neither on a traced task.
> > 
> > Why do you think so? It works in both cases (ptracer can use
> > PT_TRACE_EXIT, but the task is killed anyway).
> 
> Just from experience with tasks stuck in "T" state.  After for example
> an UML dies, some of the processes only react to SIGCONT, but not to
> SIGKILL.
> 
> I have no idea why this happens.

Anyway that should be fixed, not used as excuse for fuse misbehaviour.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
