Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbXFONA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbXFONA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbXFONAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:00:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4343 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752846AbXFONAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:00:12 -0400
Date: Fri, 15 Jun 2007 13:00:01 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       takedakn@nttdata.co.jp, hch@infradead.org
Subject: Re: [TOMOYO 5/9] Memory and pathname management functions.
Message-ID: <20070615130000.GI9442@ucw.cz>
References: <787b0d920706150016n3e941a4fj4fc2e864a7e6f7d7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920706150016n3e941a4fj4fc2e864a7e6f7d7@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>We limit the maximum length of any string data (such as
> >>domainname and pathnames) to TOMOYO_MAX_PATHNAME_LEN
> >>(which is 4000) bytes to fit within a single page.
> >>
> >>Userland programs can obtain the amount of RAM 
> >>currently
> >>used by TOMOYO from /proc interface.
> >
> >Same NACK for this as for AppArmor, on exactly the same 
> >grounds.
> >Please stop wasting your time on pathname-based 
> >non-solutions.
> 
> This issue is a very very small wart on an otherwise 
> fine idea.
> It's really not worth getting bothered by. Truth is, big 
> giant
> pathnames break lots of stuff already, both kernel and 
> userspace.

> Just look in /proc for some nice juicy kernel breakage:
> cwd, exe, fd/*, maps, mounts, mountstats, root, smaps

Well, but we should be fixing that, not adding more. And /proc is
info-only, while this is security related code.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
