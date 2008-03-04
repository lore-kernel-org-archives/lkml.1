Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbYCDUKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbYCDUKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765576AbYCDUKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:10:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1792 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764584AbYCDUKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:10:08 -0500
Date: Tue, 4 Mar 2008 21:07:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Michael Kerrisk <michael.kerrisk@googlemail.com>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
Message-ID: <20080304200701.GA5599@ucw.cz>
References: <1204119455.6242.403.camel@lappy> <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org> <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com> <alpine.LFD.1.00.0802290907480.17889@woody.linux-foundation.org> <1204305488.6243.113.camel@lappy> <alpine.LFD.1.00.0802290928200.17889@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802290928200.17889@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-29 09:29:19, Linus Torvalds wrote:
> 
> 
> On Fri, 29 Feb 2008, Peter Zijlstra wrote:
> >
> > > ... and what's the point? We've never had it before, nobody has ever cared, 
> > > and the whole notion is just stupid. Why would we want to limit it? The 
> > > only thing that the kernel *cares* about is the stack size - any other 
> > > size limits are always going to be arbitrary.
> > 
> > Well, don't think of limiting it, but querying the limit.
> > 
> > Programs like xargs would need to know how much to stuff into argv
> > before starting a new invocation.
> 
> But they already can't really do that. More importantly, isn't it better 
> to just use the whole stack size then (or just return "stack size / 4" or 
> whatever)?

Using whole stack smells like a security problem to me.

...pass so much parameters that passwd dies on stack shortage. Make
sure passwd grabbed some system-wide lock before dying.

						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
