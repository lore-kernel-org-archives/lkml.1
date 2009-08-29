Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbZH2KSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbZH2KSE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 06:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZH2KSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 06:18:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54246 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZH2KSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 06:18:01 -0400
Date: Sat, 29 Aug 2009 11:36:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #13646] warn_on tty_io.c, broken bluetooth
Message-ID: <20090829093657.GC1634@ucw.cz>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera> <Cg6cQYLdUxG.A.f2B.l0GlKB@chimera> <84144f020908252314l364588bfi16e2d426cece2c5a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020908252314l364588bfi16e2d426cece2c5a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-08-26 09:14:02, Pekka Enberg wrote:
> On Wed, Aug 26, 2009 at 12:05 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30. ?Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry ? ? ? : http://bugzilla.kernel.org/show_bug.cgi?id=13646
> > Subject ? ? ? ? : warn_on tty_io.c, broken bluetooth
> > Submitter ? ? ? : Pavel Machek <pavel@ucw.cz>
> > Date ? ? ? ? ? ?: 2009-06-19 17:05 (68 days old)
> > References ? ? ?: http://lkml.org/lkml/2009/6/19/187
> 
> Pavel, is this still an open issue? Plenty tty fixes went into 2.6.31
> so maybe we need to backport some of them to -stable?

It seems to be interminent, and depends on timing/usage patterns. (Try
to start bluetooth when it is already starting). It
is possible that it was there before. Perhaps it can be just closed as
'bug but not regression'.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
