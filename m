Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbXFUSWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbXFUSWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbXFUSWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:22:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57008 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754145AbXFUSWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:22:15 -0400
Date: Thu, 21 Jun 2007 20:22:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       takedakn@nttdata.co.jp, hch@infradead.org
Subject: Re: [TOMOYO 5/9] Memory and pathname management functions.
Message-ID: <20070621182205.GB18990@elf.ucw.cz>
References: <787b0d920706150016n3e941a4fj4fc2e864a7e6f7d7@mail.gmail.com> <20070615130000.GI9442@ucw.cz> <787b0d920706160208u62f8a2c5q5f94f5986d755d24@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920706160208u62f8a2c5q5f94f5986d755d24@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> It's really not worth getting bothered by. Truth is, big
> >> giant
> >> pathnames break lots of stuff already, both kernel and
> >> userspace.
> >
> >> Just look in /proc for some nice juicy kernel breakage:
> >> cwd, exe, fd/*, maps, mounts, mountstats, root, smaps
> >
> >Well, but we should be fixing that, not adding more. And /proc is
> >info-only, while this is security related code.
> 
> Security tools read from /proc, so /proc is security-related.

If some tool relies on pathnames in /proc, that tool is broken... as
is /proc. We should be fixing that.

> The limit imposed by TOMOYO (or AppArmor) is fine,
> despite being security-related. It just needs to fail in

It is not "fine", but maybe it will not get us a bugtraq posting.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
