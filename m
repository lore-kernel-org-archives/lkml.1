Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbXD2Sqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbXD2Sqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 14:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbXD2Sqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 14:46:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38358 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbXD2Sqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 14:46:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Linux 2.6.21
Date: Sun, 29 Apr 2007 20:50:55 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070426040806.GJ3468@stusta.de> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org>
In-Reply-To: <20070429173725.GB30248@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704292050.56575.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 April 2007 19:37, Andi Kleen wrote:
> > My personal experience with bugzilla is that it's very unfriendly to
> > reporters.  IMHO it's suitable for tracking unresolved problems along with
> > debug patches, system information etc., but not for _reporting_ new ones.
> 
> What did you find unfriendly? 

- You are required to select a category and 'component' for your report, which
often is difficult (especially if you're not a kernel expert)
- You need to have a bugzilla account (or to create one, if you don't)
- If you want to add an address to the CC list, it must be known to bugzilla
and there's no (obvious) way to check which addresses are known (bugzilla
rejects the report if there's a 'wrong' email address in the list)  [IMO this is
really really broken.]
- You are asked to provide many details that need not be relevant and casual
reporters don't know that they can skip this part
- Attaching files is tedious and referring to attachments unintuitive

> While I also cannot say I love it I don't find it any less unfriendly
> than an email.

That depends (please see below).

> Besides the primary point of bug tracking is not to be friendly
> to someone, but to (a) fix the bugs and (b) know how many bugs
> there for a given release. Any replacement would need to solve
> this problem too.

For _tracking_ bugs, the bugzilla is more-or-less suitable.
For _reporting_ bugs, IMHO, it's not.

And I think they are two _totally_ conceptually different things.  You report
a bug to let somebody know that there's a problem and this doesn't necessarily
mean that the problem has to be tracked.  It may be very simple and immediately
resolvable, in which case registering it in bugzilla is a loss of time and
resources.  If the problem _turns_ _out_ to be difficult, _then_ it'll need to
be tracked, but usually it's not known whether or not this is the case until
someone 'in the know' looks at the initial report.

For this reason there should be a simple means of filing initial bug reports
with someone to look at them and forward them to appropriate people who will
decide if the problem needs to be tracked.  If they do, it's time to use
bugzilla.  Not earlier.

> Email does not solve it as far as I can see.

You are right, email is not suitable for tracking bugs.  Still, it works quite
well as a means of sending initial reports.

Greetings,
Rafael
