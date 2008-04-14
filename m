Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbYDNKIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbYDNKIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbYDNKH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:07:58 -0400
Received: from 1wt.eu ([62.212.114.60]:3093 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbYDNKH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:07:58 -0400
Date: Mon, 14 Apr 2008 12:00:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Tilman Schmidt <tilman@imap.cc>,
       Valdis.Kletnieks@vt.edu, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jesper.juhl@gmail.com,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Reporting bugs and bisection
Message-ID: <20080414100018.GA10378@1wt.eu>
References: <47FEADCB.7070104@rtr.ca> <22880.1207943922@turing-police.cc.vt.edu> <47FFE5DA.8000709@imap.cc> <200804132040.12138.rjw@sisk.pl> <20080413184730.GD8474@1wt.eu> <874pa4wyfj.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874pa4wyfj.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 11:58:08AM +0200, Andi Kleen wrote:
> Willy Tarreau <w@1wt.eu> writes:
> 
> > Linux is the *only* product which requires
> > the bug reporter to find the fault change (yes, I know, it's scalable).
> 
> It's a pretty common procedure for compilers (gcc, llvm) too, although
> they have the advantage that given a test case usually someone else
> can run the bisect procedure because they do not depend on the underlying
> hardware 
> 
> That's unfortunately not the case for most kernel bugs, although
> sometimes it is possible given a hardware independent test case. And
> while most of the kernel code is drivers and arch, a lot of it is
> still pretty hardware independent, so at least in some cases it is
> possible to submit test cases and then let someone else (like a bug
> master) do the bisect.
> 
> Of course it is unclear if producing a submittable test case will be
> actually any faster than just running bisect for the user.
> 
> That said I agree it's a big burden to run bisect for everything
> because it can take very long (especially if the problem
> is not trivially reproducable) 
> 
> It would be fair at least if maintainers always gave some candidate
> commit ids when asking for bisect for likely changes that could
> have matched the bug.  Then those could be checked quickly first
> before doing the full run.
> 
> While that will not always work it would be still a useful short cut
> and save a lot of time for the reporter.

And most of all, the reporter would not feel like the bisection is
the default response !

> -Andi

Willy

