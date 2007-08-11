Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbXHKFbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbXHKFbD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 01:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXHKFax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 01:30:53 -0400
Received: from 1wt.eu ([62.212.114.60]:1301 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbXHKFaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 01:30:52 -0400
Date: Sat, 11 Aug 2007 07:15:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Michael Chang <thenewme91@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070811051548.GA24082@1wt.eu>
References: <20070801175004.GA17936@elte.hu> <Pine.LNX.4.64.0708011955430.1817@scrub.home> <20070801190556.GA1199@elte.hu> <Pine.LNX.4.64.0708100037460.1817@scrub.home> <20070810054948.GA5908@elte.hu> <Pine.LNX.4.64.0708101459530.1817@scrub.home> <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com> <Pine.LNX.4.64.0708101919270.1817@scrub.home> <20070810194705.GH6002@1wt.eu> <Pine.LNX.4.64.0708102235320.1817@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708102235320.1817@scrub.home>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 11:15:55PM +0200, Roman Zippel wrote:
> Hi,
> 
> On Fri, 10 Aug 2007, Willy Tarreau wrote:
> 
> > fortunately all bug reporters are not like you. It's amazing how long
> > you can resist sending a simple bug report to a developer!
> 
> I'm more amazed how long Ingo can resist providing some explanations (not 
> just about this problem).

It's a matter of time balance. It takes a short time to send the output
of a script, and it takes a very long time to explain how things work.
I often encounter the same situation with haproxy. People ask me to
explain them in detail how this or that would apply to their context, and
it's often easier for me to provide them with a 5-lines patch to add the
feature they need, than to spend half an hour explaining why and how it
would badly behave.

> It's not like I haven't given him anything, he already has the test 
> programs, he already knows the system configuration.
> Well, I've sent him the stuff now...

fine, thanks.

> > Maybe you
> > consider that you need to fix the bug by yourself after you understand
> > the code,
> 
> Fixing the bug requires some knowledge what the code is intended to do.
> 
> > Please try to be a little bit more transparent if you really want the
> > bugs fixed, and don't behave as if you wanted this bug to survive
> > till -final.
> 
> Could you please ask Ingo the same? I'm simply trying to get some 
> transparancy into the CFS design. Without further information it's 
> difficult to tell, whether something is supposed to work this way or it's 
> a bug.

I know that Ingo tends to reply to a question with another question. But
as I said, imagine if he has to explain the same things to each person
who asks him for it. I think that a more constructive approach would be
to point what is missing/unclear/inexact in the doc so that he adds some
paragraphs for you and everyone else. If you need this information to debug,
most likely other people will need it too.

> In this case it's quite possible that due to a recent change my testcase 
> doesn't work anymore. Should I consider the problem fixed or did it just 
> go into hiding? Without more information it's difficult to verify this 
> independently.

generally, problems that appear only on one person's side and which suddenly
disappear are either caused by some random buggy patch left in the tree (not
your case it seems), or by an obscure bug of the feature being tested which
will resurface from time to time as long as it's not identified.

Willy

