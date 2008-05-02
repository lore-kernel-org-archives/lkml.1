Return-Path: <linux-kernel-owner+w=401wt.eu-S935367AbYEBPdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935367AbYEBPdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763658AbYEBPda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:33:30 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:44220 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761842AbYEBPd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:33:29 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Slow DOWN, please!!!
Date: Fri, 2 May 2008 17:33:13 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Noe <dpn@isomerica.net>,
       torvalds@linux-foundation.org, rjw@sisk.pl, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
References: <20080429.190352.137408408.davem@davemloft.net> <200805010053.31894.m.kozlowski@tuxland.pl> <87od7pf1ne.fsf@basil.nowhere.org>
In-Reply-To: <87od7pf1ne.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021733.13553.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > Speaking of energy and time of a tester. I'd like to know where these resources
> > should be directed from the arch point of view. Once I had a plan to buy as
> > many arches as I could get and run a farm of test boxes 8-) But that's hard
> > because of various reasons (money, time, room, energy). What arches need more
> > attention? Which are forgotten? Which are going away? For example does buying
> > an alphaserver DS 20 (hey - it's cheap) and running tests on it makes sense
> > these days?
> 
> A lot of bugs are not architecture specific. Or when they are architecture
> specific they only affect some specific machines in that architecture.

Yes, there is some amount of bugs that I see only on specific architecture.
These which are reproducible or have an easy test case I do report to LKML, but
there are also bugs I see rarely or just once and they never come back and sometimes
as a bonus leave no trace - and these I ususaly don't report. Providing a test case
is a challenge and one can really learn a lot.

> But really a lot of bugs should happen on most architectures. Just focussing
> on lots of boxes is not necessarily productive.

What I meant was one box per architecture, preferably an SMP one where possible - so
the number of required boxes is limited. This way instead of just cross-compiling
I could actually _run_ the kernel. On the other hand if some arch is close to be dead
and has no foreseable future then there is no point in testing it.

Also my thinking was that sometimes bugs from other (than x86) architectures can point to
some more generic problems. Well - I'll buy just a few more and that's it ;)

> My recommendation would be to concentrate on deeper testing (more coverage)
> on the architectures you have.

Can do.
 
> A interestig project for example would be to play with the kernel gcov patch that
> was recently reposted (I hope it makes mainline eventually). Apply that patch,
> run all the test suites and tests you usually run on your favourite test box
> and check how much of the code that is compiled into your kernel was really tested
> using the coverage information Then think: what additional tests can you do to get 
> more coverage?  Write tests then? Or just write descriptions on what is not tested 
> and send them to the list, as a project for others looking to contribute to the 
> kernel.

Sounds like a plan - will look into that.
 
	Mariusz aka arch'aeologist ;)
