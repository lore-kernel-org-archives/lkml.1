Return-Path: <linux-kernel-owner+w=401wt.eu-S1762800AbYBSLXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762800AbYBSLXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760180AbYBSLW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:22:56 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45879 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758665AbYBSLWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:22:54 -0500
Date: Tue, 19 Feb 2008 11:11:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] suspend/resume self-test
Message-ID: <20080219101116.GA2202@elf.ucw.cz>
References: <20080130131748.GA3796@elf.ucw.cz> <200802180240.47510.david-b@pacbell.net> <20080218130914.GC17697@elte.hu> <200802181216.25350.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802181216.25350.david-b@pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-02-18 12:16:24, David Brownell wrote:
> On Monday 18 February 2008, Ingo Molnar wrote:
> > 
> > * David Brownell <david-b@pacbell.net> wrote:
> > 
> > > > >   - Includes a command line parameter, which needs work yet ... it
> > > > >     currently turns this test off, but it should also let the target
> > > > >     state be specified (and maybe even default to "no test").
> > > 
> > > I think "no test" should be the default; STR working sanely on x86 is 
> > > unfortunately too much a surprise.  Someone more active in PM testing 
> > > should update that.
> > 
> > All i'm asking for is to make the self-test easily accessible. Not for 
> > it to blow up in the face of users who do not ask for it.
> 
> I'm all for that, but also I don't want to see it blow up regularly
> in the face of people who just enable all the selftest options.  The
> other tests have a much better expectation of working "by default".

> > And, at least to me, there seems to be a rather apparent correlation 
> > between "suspend/resume regressions caught as early as possible" and the 
> > future, desired state of: "STR working sanely on x86" ;-)
> 
> Thing is, this will catch not just regressions ... but cases where
> STR never worked in the first place.  Video problems, etc.  Also
> various system startup races, as in the PCMCIA and MMC/SD/SDIO
> cases I noted.

David is right here. At minimum, s2ram needs acpi_sleep=... options to
tell it how to set up the video. That is not issue for you, but it
means we should not be doing it by default.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
