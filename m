Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbYBRNJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbYBRNJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYBRNJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:09:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60092 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbYBRNJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:09:42 -0500
Date: Mon, 18 Feb 2008 14:09:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] suspend/resume self-test
Message-ID: <20080218130914.GC17697@elte.hu>
References: <20080130131748.GA3796@elf.ucw.cz> <20080218094650.GA31970@elte.hu> <20080218095325.GA7198@elf.ucw.cz> <200802180240.47510.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802180240.47510.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Brownell <david-b@pacbell.net> wrote:

> > >   - Includes a command line parameter, which needs work yet ... it
> > >     currently turns this test off, but it should also let the target
> > >     state be specified (and maybe even default to "no test").
> 
> I think "no test" should be the default; STR working sanely on x86 is 
> unfortunately too much a surprise.  Someone more active in PM testing 
> should update that.

All i'm asking for is to make the self-test easily accessible. Not for 
it to blow up in the face of users who do not ask for it.

And, at least to me, there seems to be a rather apparent correlation 
between "suspend/resume regressions caught as early as possible" and the 
future, desired state of: "STR working sanely on x86" ;-)

You really seem to treat S2R suckiness as a fact of life, but it isnt. 
Yes, it's a hard field for a number of reasons, but we could be doing _a 
lot_ better. One of them would be this "notice s2r breakage when i 
create or add the patch that breaks it" angle.

        Ingo

