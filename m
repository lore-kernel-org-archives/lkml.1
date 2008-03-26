Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbYCZLXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbYCZLXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYCZLX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:23:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42206 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbYCZLX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:23:28 -0400
Date: Wed, 26 Mar 2008 12:23:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Andy Whitcroft <apw@shadowen.org>, David Miller <davem@davemloft.net>,
       jirislaby@gmail.com, viro@ZenIV.linux.org.uk, joe@perches.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
	- formatting only
Message-ID: <20080326112311.GG17176@elte.hu>
References: <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu> <20080325160734.GA14583@logfs.org> <20080326095249.GD22584@shadowen.org> <20080326102654.GB22847@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080326102654.GB22847@logfs.org>
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


* Jörn Engel <joern@logfs.org> wrote:

> > > (foo*) should be (foo *)
> > > 	What does that extra space gain us?
> > 
> > It really gains us nothing, however that is not really the point. 
> > The point is that consistancy is good, with the space is the more 
> > normal 'C' usage, without for 'C++'; something to do with the 
> > implication that (foo *) is a pointer to a foo (separate things), 
> > and (foo*) is a thing of type pointer to foo (one thing) which is 
> > more object oriented.
> > 
> > The "norm" is with and so it makes sense to maintain it that way.  A 
> > lot of the layout and style choises are arbitrary, and disliked by 
> > many of us, but we follow the style to maintain that common feel.
> 
> Then I'll happily ignore it.  Not having the space gains me one 
> column. It is absolutely minimal, sure.  But when the alternative is 
> based on pure whim...

you seem to be confused here. Consistency is not a 'whim', and it is 
often just about "arbitrary" choices that also have some ergonomic 
component as well (but sometimes not). The following form:

  if(x)
  {
          MyFunction1();
          MyFunction2();
  }

can be argued to be just as clean (and just as ergonomic) as:

  if (x) {
          my_function_1();
          my_function_2();
  }

if you use it consistently throughout the _whole_ codebase.

what does not make sense is to _mix_ different coding styles, especially 
within the same source code block - which you do in that specific file.

or is it your argument that consistent coding style is bad? That 
argument has been settled long ago with the creation of 
Documentation/CodingStyle. All kernel code is supposed to follow that 
style, unless the resulting line of code looks clearly _wrong_. Your 
arguments seem to center around "hey, my way it looks similarly good so 
i'll do that instead because i'm the maintainer" - and that argument 
does not fly. CodingStyle is definitely not gospel and common sense 
should be applied, but _arbitrarily_ and _intentionally_ deviating from 
it is considered bad manners and hurts Linux as a whole.

granted, especially in the driver space, where there's a lack of 
maintenance resources, all such secondary rules are weaker - because a 
somewhat quirky maintainer is still much better to Linux than no 
maintainer. But the closer you get to the core kernel, the higher the 
code quality stakes get, and the stricter (and the more consistent) 
these style requirements become as well.

	Ingo
