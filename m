Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbXAWIsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbXAWIsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 03:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932907AbXAWIsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 03:48:22 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4667 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932908AbXAWIsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 03:48:21 -0500
Date: Tue, 23 Jan 2007 08:48:07 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: Valdis.Kletnieks@vt.edu, David Wagner <daw@cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Undo some of the pseudo-security madness
Message-ID: <20070123084805.GB5560@ucw.cz>
References: <87r6toufpp.wl@betelheise.deep.net> <200701221520.l0MFKLdK032645@turing-police.cc.vt.edu> <871wlnq7ue.wl@betelheise.deep.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871wlnq7ue.wl@betelheise.deep.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > not "core-dumps" but "core files", in the lispspeak, but anyway.
> > > 
> > > the reason is trivial -- if i can write programs enjoying setuid
> > > privileges in C, i want to be able to do the same in Lisp.
> > 
> > Go read up on how the XEmacs crew designed their "portable dumper",
> > specifically to get around a lot of these sorts of problems because the
> > old Emacs 'unexec' code was incredibly fragile.
> 
> I should take the freedom to respond in your manner :-)
> 
> Are you saying that the usefulness of AS randomisation is
> overall exceeding that of MAP_FIXED, and the latter should be
> abolished?

MAP_FIXED still works. You just have to be more careful where you map.

> > > the only way to achieve this i see, is to directly setuid root
> > > the lisp system executable itself -- because the lisp code
> > > is read, compiled and executed in the process of the lisp
> > > system executable.
> > 
> > If that's the only way you can see to do it, maybe you should think a
> > bit harder before making kernel hacks to do something.
> 
> I want equal grounds for platforms, that`s all.

Well, noone ever said all languages are equal. You have crappy lisp
interpreters, and you want to break kernel because you are too lazy to
fix them, and insist they must do suid in any way you choose. We won't
break kernel because lisp is misdesigned.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
