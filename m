Return-Path: <linux-kernel-owner+w=401wt.eu-S1759064AbYEADZC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064AbYEADZC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 23:25:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbYEADYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 23:24:52 -0400
Received: from gherkin.frus.com ([192.158.254.49]:33253 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbYEADYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 23:24:52 -0400
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <4818EA2C.2040507@zytor.com> "from H. Peter Anvin at Apr 30, 2008
 02:52:44 pm"
To: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 30 Apr 2008 22:24:40 -0500 (CDT)
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080501032440.D8394DBA4@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Linus Torvalds wrote:
> > 
> > The tester base is simply too small.
> > 
> > Now, if *that* could be improved, that would be wonderful, but I'm not 
> > seeing it as very likely.
> > 
> 
> One thing is that we keep fragmenting the tester base by adding new 
> confidence levels: we now have -mm, -next, mainline -git, mainline -rc, 
> mainline release, stable, distro testing, and distro release (and some 
> distros even have aggressive versus conservative tracks.)  Furthermore, 
> thanks to craniorectal immersion on the part of graphics vendors, a lot 
> of users have to run proprietary drivers on their "main work" systems, 
> which means they can't even test newer releases even if they would dare.

Since I poke my head out of the foxhole every once in a while with a
relatively late-breaking bug report, I thought I should chime in...
Mr. Anvin has pretty much nailed it...

As the kernel development process has evolved, which "confidence level"
I select has evolved as well.  The thing that *hasn't* changed through
the years is, I tend to pick a "confidence level" that is appropriately
close to "mainline" and has an update release schedule roughly compatible
with my ability to keep up with it.  Specifically, if it takes me several
hours to download a patch set, apply it, build the new kernel, and test
on multiple platforms/architectures, then the update release schedule is
probably going to have to be no more often than twice a week if I'm going
to be at all interested in even trying to keep up with it.  In 2008, the
"-rcX" updates are a good fit.  In the not-too-distant past, keeping up
with 2.5.X.Y was no problem.

Yes, I realize I don't *have* to test every revision level in every
major tree, but I don't have to think about which one to pick for testing
if I can keep up with the update release schedule :-).

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
