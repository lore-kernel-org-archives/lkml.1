Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbYAYMA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbYAYMA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 07:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYAYMAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 07:00:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48175 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbYAYMAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 07:00:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Valdis.Kletnieks@vt.edu
Subject: Re: Linux 2.6.24
Date: Fri, 25 Jan 2008 12:58:08 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Giacomo A. Catenazzi" <cate@cateee.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org> <4799A773.2030702@cateee.net> <22000.1201255093@turing-police.cc.vt.edu>
In-Reply-To: <22000.1201255093@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251258.08707.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 25 of January 2008, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 25 Jan 2008 10:10:11 +0100, "Giacomo A. Catenazzi" said:
> 
> > As a tester I would like:
> > - slow merges, so that developer could rebase and test
> >    (compile test) the interaction of the new code.
> 
> An amazing amount of stuff gets caught when it's tested in Andrew Morton's -mm
> tree.  You think -rc1's are bad now, consider that much of what will be
> 25-rc1 already got tried as 24-rc6-mm1 and 24-rc8-mm1.  Without those, the
> -rc1 releases would be truly horrific.. ;)
> 
> > - you will introduce a new step on git management:
> >    Every changeset is compile-tested before going out to the world.
> >    I think this can be done automatically, and I think that one or
> >    two configurations are enough to find most of the problems.
> 
> It's true that a compile on x86 and a compile on PowerPC

Please add IA-64 and ARM at the very least.

> should flush out 
> most of the truly stupid mistakes, but those are usually found and fixed
> literally within hours.  Anyhow, the proper time for test compiles is *before*
> it goes into the git trees at all - it should have been tested before it
> gets sent to a maintainer for inclusion.

That's correct, but I'm not sure how to enforce it.

> Plus, there's a *lot* of issues that "one or two configurations" won't
> find - we continually find build issues that literally depend on 3 or 4
> different CONFIG_* settings, and only misbehave for one specific combination.
> And all the things that compile clean but explode at runtime.

Absolutely.

I whish there would be more time for testing things during merge windows.

Greetings,
Rafael
