Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbYGOPwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbYGOPwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYGOPwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:52:15 -0400
Received: from r00tworld.com ([212.85.137.21]:37850 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbYGOPwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:52:14 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Jul 2008 17:31:09 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487CDEDD.21049.1ACFDAEA@pageexec.freemail.hu>
In-reply-to: <alpine.LFD.1.10.0807141924020.3017@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487C242B.19490.17F690F7@pageexec.freemail.hu>, <alpine.LFD.1.10.0807141924020.3017@woody.linux-foundation.org>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Tue, 15 Jul 2008 17:31:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Jul 2008 at 19:27, Linus Torvalds wrote:

> We went through this discussion a couple of weeks ago, and I had 
> absolutely zero interest in explaining it again.

sorry, i was unaware of that discussion. any quick URLs?

> I personally don't like embargoes. I don't think they work. That means 
> that I want to fix things asap. But that also means that there is never a 
> time when you can "let people know", except when it's not an issue any 
> more, at which point there is no _point_ in letting people know any more.

i don't follow you here. you're making 4 statements essentially:

A. 'i want to fix bugs asap'
B. 'i can let people know only when it's not an issue any more'
C. 'there is no point in letting people know when it's not an issue any more'
D. A implies B and/or C

let's see them one by one.

A: fine and even commendable.

B: that's part of the disclosure policy, so be it, although it raises
   the question of *when* a bug is no longer an issue. when the fix is
   in your git tree? in all/some affected vendor trees? in all affected
   linux trees in existence? or does it depend on when x % of the
   affected machines is running it? what's your criterion?

C: do you realize what you just said? effectively, 'there's no point
   in disclosure'. that's diametrically opposite to what you previously
   argued for (rather vehemently, as vendor-sec readers surely remember).
   to remind yourself of your own words:

     http://lkml.org/lkml/2005/1/12/205
     http://lkml.org/lkml/2005/1/12/363
     http://lkml.org/lkml/2005/1/13/305

   in any case, who decided this? you? did you ask anyone actually
   affected (vendors, users, whatnot)? in case you missed about two
   decades of security problems and their (mis)handling by proprietary
   vendors, this was the *exact* reason why they got shamed repeatedly
   in public (does bugtraq mean anything to you?) and why we have
   public security mailing lists and a whole industry nowadays.

D: this one is a non-sequitur, the timeline (or even willingness) of
   fixing bugs does not imply their disclosure policy. you can surely
   fix a bug independently of telling about it. so the question stays:
   why do you think not disclosing security impact info at all is good,
   and is what users want?

> So I personally consider security bugs to be just "normal bugs".

security bugs aren't just 'normal bugs', the more serious of them
allow to completely break the security model of the kernel. the world
at large has long ago decided that such bugs *are* special and there's
an entire industry dedicated to finding/fixing/exploiting/etc them,
not to mention academic research of the same. you can't ignore reality
like that, i'm afraid.

> I don't cover them up,

by 'cover up' i meant that even when you know better, you quite
consciously do *not* report the security impact of said bugs - that's
the part called 'cover up' because it's about the opposite of full
disclosure that you also advocated in the past. now you made it clear
that you don't actually (want to) practice it (i'm not arguing with
that choice btw, just pointing out the inconsistency between your
declared words and actual actions).

> but I also don't have any reason what-so-ever to think it's 
> a good idea to track them and announce them as something special. 

see my comment about reality above. heck, even linux vendors do track
and announce them, it's part of the support they provide to paying
customers (and even non-paying users).

> So there is no "policy". Nor is it likely to change. 

obviously there *is* a policy, it's just not what you guys declared
earlier in Documentation/SecurityBugs. would you care to update it
or, more properly, remove it altogether as it currently says:

  Linux kernel developers take security very seriously.  As such, we'd
  like to know when a security bug is found so that it can be fixed and
                      ^^^^^^^^^^^^
  disclosed as quickly as possible.  Please report security bugs to the
  ^^^^^^^^^
  Linux kernel security team.

and what you said above about disclosure and treatment of security bugs
is the opposite of it. there is no reason for the kernel security list
to exist, basically (you already have lkml and bugzilla to discuss bugs,
which, according to you, security bugs are as well, there's no need for
special treatment).

cheers,
  PaX Team

PS: i do wonder however, how do you and others expect people to track the
quality of the development process if you apparently refuse to properly
account for security bugs? at this moment the Jeff Jones of the world are
smacking their head realizing the extent their statistics were flawed and
will no doubt have a field day with your statements.

