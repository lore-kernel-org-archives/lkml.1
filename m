Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbZJ0DCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbZJ0DCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 23:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbZJ0DCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 23:02:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44893 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbZJ0DCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 23:02:42 -0400
Subject: Re: [RFC] to rebase or not to rebase on linux-next
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       nico@fluxnic.net, tony.luck@intel.com, sfr@canb.auug.org.au,
       mcgrof@gmail.com, jeff@garzik.org, robert.richter@amd.com,
       dmitry.torokhov@gmail.com, khali@linux-fr.org,
       torvalds@linux-foundation.org
In-Reply-To: <20091026.183416.52095233.davem@davemloft.net>
References: <1256601061.26028.350.camel@gandalf.stny.rr.com>
	 <20091026.171539.06989895.davem@davemloft.net>
	 <1256603403.26028.358.camel@gandalf.stny.rr.com>
	 <20091026.183416.52095233.davem@davemloft.net>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 23:02:38 -0400
Message-Id: <1256612558.26028.391.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 18:34 -0700, David Miller wrote:

> > My testing is mostly done in Ingo's test suite, and that happens after I
> > do my push to him. This works best for me.
> 
> So you both should keep your trees private until it's all sorted out
> and you have the results in hand.
> 
> Nobody forces you guys to use public trees just to run Ingo's personal
> test suite, you have decided to work that way.  And that is therefore
> something you guys can change without effecting other people.

I guess we have a different point of view on this. We like to keep
things public as much as possible. As stated earlier, it's easier to get
people to test the patches if the git trees in question are available.

90% of the bugs are found by Ingo's tests, the other 10% is found by
people pulling one of our git trees and testing themselves.

> 
> > If I had to publish and let cook on LKML, then I would also need to keep
> > better accounting of what I have pushed out and what I have left to do.
> 
> The problem isn't that you have to push patches out and only work
> with patches, the problem is that you want to use publicly visible
> GIT trees to do your testing at all times.
> 
> And sorry, that is not how you're supposed to do things.

That is a matter of opinion. We prefer to keep things as public as
possible. No patches back and forth privately doing our own internal
test suites, then come out with some "production release". If someone
found something wrong with it then, we would need to start the cycle all
over again.

I do not like to send patches to anyone privately, unless it is a hack
that is to help someone debug something and not for inclusion. Any time
I send out a patch to be included for mainline, I start it out public. I
also prefer to have a public git repo available to be tested by anyone.

Whether I'm sending a patch to Ingo, Linus, Andrew, or even you, I would
do it publicly and have a git repo to pull from for simplicity.

-- Steve


