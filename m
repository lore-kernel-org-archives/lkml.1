Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYAZL24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYAZL24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 06:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYAZL2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 06:28:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48124 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbYAZL2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 06:28:46 -0500
Date: Sat, 26 Jan 2008 12:28:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Giacomo A. Catenazzi" <cate@cateee.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Valdis.Kletnieks@vt.edu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: using LKML for subsystem development (was Re: Linux 2.6.24)
Message-ID: <20080126112820.GA10563@elte.hu>
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org> <4799A773.2030702@cateee.net> <22000.1201255093@turing-police.cc.vt.edu> <200801251258.08707.rjw@sisk.pl> <4799D770.2070203@cateee.net> <479A75D4.6070607@s5r6.in-berlin.de> <479A8203.40804@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479A8203.40804@s5r6.in-berlin.de>
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


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> [...] How will subscribers of LKML decide which discussion threads in 
> the huge amount of traffic are worth to glance at?  Each of us has 
> only a limited amount of time for LKML consumption.

uhm. How do you decide which of the 10000 git commits per upstream 
kernel release (more than 100 a day) you'll look at?

easy: you download the full git tree from Linus, to have all the 
information in one place, but you then you use filters, because you are 
not interested in the whole 9 million lines of kernel code.

You use filters such as:

   git-log drivers/net/

Note what you dont get: you dont get to download just drivers/net and 
nothing else. It makes no sense in isolation because this is a single 
kernel codebase that is released as one logical unit. Everyone who finds 
a bug in the kernel can be assumed to have access to the full kernel 
source. If we talk about the "upstream kernel", we all can rely on all 
of us having access to the full body of information we do development 
on. This unified information base is _powerful_ stuff.

and by logical extension, the public development "metadata" of that 
unified source tree should be ... just as easily accessible. Such as ... 
a single forum of discussion - an email list for example.

People who dont want to follow the whole, will ... filter.

For example they will only open the threads they are interested in.

Or you dont even have to read all the subjects: you can filter on "net" 
subjects for example, that filter took 2 seconds to apply for my mailer, 
on 37119 mails in my lkml folder, and this reduced the number of 
messages to 3959 - about 10% of the total size.

Or filter on _people_. The "domain experts" you are interested in. 
Filter on all mails from David S. Miller if you are interested in 
networking topics. You'll have a really good grasp of what's going on in 
that area, without having to invest too much time.

Or subscribe to lwn.net who do weekly updates with links to lkml. If you 
dont have the time, you might have the money to pay people who have the 
time to do work for you. (or if that's still too much, follow the 
time-deferred lkml updates of lwn.net)

Realize it: it's _far_ easier to filter down a too verbose source of 
information, than to put scattered, inaccessible pieces of information 
back together. It's far easier to get a cup of water from the open 
firehose than it is to gather the drops once they spilled on the ground. 
Sure, it all seems easier if you get everything presented on a nice 
little mailing list, with just the right people subscribed - but that 
isolation is the same kind of "closed source" thinking that causes so 
many problems in computing today.

lkml is about using this whole "open development" idea and pushing it to 
its logical conclusion. "Domain experts" hiding away in caves is just a 
fancy excuse for something much different and it can be really harmful 
to the end result (the kernel's quality). Most of the subsystems already 
do their development on lkml, but it could be further improved upon.

	Ingo
