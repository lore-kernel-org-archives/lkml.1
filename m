Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbXHTPZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbXHTPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbXHTPZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:25:16 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:54308 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759338AbXHTPZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:25:14 -0400
Date: Mon, 20 Aug 2007 11:25:12 -0400
To: Marc Perkel <mperkel@yahoo.com>
Cc: Brennan Ashton <comphappy@gmail.com>, Nix <nix@esperi.org.uk>,
       Al Viro <viro@ftp.linux.org.uk>, Kyle Moffett <mrmacman_g4@mac.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       Michael Tharp <gxti@partiallystapled.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
Message-ID: <20070820152512.GE9412@csclub.uwaterloo.ca>
References: <b2d05de20708200047s6da64412tf6c5afc0b8dea540@mail.gmail.com> <465458.84259.qm@web52505.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465458.84259.qm@web52505.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 04:18:21AM -0700, Marc Perkel wrote:
> Look at the reality of the situation. Linux is free
> and yey it can't compete with operating systems that
> are paid for. Maybe the reason is that when someone
> point out the something is broken all yopu get is
> justification and excuses and insults.

And when someone points out windows is broken, Microsoft doesn't give a
damn and you can't do a thing about it.

> Read the thread from the beginning and you'll see that
> I started out that way. 
> 
> If you attack people who are pointing out flaws and
> making suggestions then people will stop pointing out
> flaws and making suggestions.

Just because you think they are flaws doesn't mean they are.  Your
complaint of rm * certainly fits that.  You just didn't know what you
were doing or you would have realized rm * was the wrong thing to use.

> Think about it. Why did it take 20 years for Linux to
> fix the RM problem? If you type RM * you expect the
> files to be gone, not some stupid error that I'm
> trying to delete too many files.

There is no problem with rm *.  The wildcard expansion is done by the
shell, and different shells have different maximum command line lenghts
(it would be pretty inefficient to allow infinite command lines).
Windows makes the stupid choice that every single program has to invent
and support wildcard expansion on its own.  This means most commands on
windows don't support wildcards at all.  At least doing it in the shell
makes unix consistent and much more flexible for the user.  In a few
cases you may have a wildcard that expands to too much.  Well that is
why we have find and xargs and such.  It was a known limitation, and an
efficient solution was invented to deal with the unusual case of too
many files matching a wildcard.  Not a problem, nothing to fix.

> So who's fault is that? I say it's a problem with
> Linux culture. If something is broken you have to
> justify it instead of fixing it.

The user was at fault for doing something stupid and not using the right
tools for the job.

> If developers take that kind of attitude then progress
> stops.

You prefer the developer telling you that you have to not use wildcards
and type all filesnames manually (as windows would for most commands),
or that instead they make the system allocate all system ram for your
command line just in case you decide you should delete 2 billion files
at once with rm *?

> You guys are trying to may the RM problem MY FAULT
> because I didn't say it nicely. We'll it doesn't have
> to be said nicely. If something is broken then it
> needs fixed regardless of who and how it is pointed
> out.
> 
> A BUG is a BUG is a BUG. You fix bugs, not make
> excuses and try to explain it away. If you went up to
> any computer user and asked them if when they type "rm
> *" that they expect the files to be deleted they will
> say "yes". Yet in the Linux work the command doesn't
> work. And it's not like it breaks after MILLIONS of
> files. It breaks on just a few thousand files, if
> that.

Not a bug.  A design decision.  A sensible one at that, and one to which
a workaround exists (which happens to be faster than rm * too).

--
Len Sorensen
