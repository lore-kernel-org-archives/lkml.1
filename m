Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYGOCP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYGOCP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYGOCPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:15:48 -0400
Received: from r00tworld.com ([212.85.137.21]:49459 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbYGOCPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:15:47 -0400
From: pageexec@freemail.hu
To: Greg KH <greg@kroah.com>
Date: Tue, 15 Jul 2008 04:14:35 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487C242B.19490.17F690F7@pageexec.freemail.hu>
In-reply-to: <20080714120418.GA5334@kroah.com>
References: <20080703185727.GA12617@suse.de>, <486D4541.25808.C600354@pageexec.freemail.hu>, <20080714120418.GA5334@kroah.com>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Tue, 15 Jul 2008 04:15:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Jul 2008 at 5:04, Greg KH wrote:

> Sorry for the delay, was on vacation...

a collective one, i take it, as noone else bothered to respond either ;).

anyway, you must have been at an interesting place i suppose as you
even managed to slip a mail through a wormhole that somehow arrived
here on 8th ;).

> > On 3 Jul 2008 at 11:57, Greg KH wrote:
> > 
> > > On Thu, Jul 03, 2008 at 10:29:14AM -0700, Greg KH wrote:
> > > Adding 2 more addresses to this thread, as they were said to have
> > > questions about this kernel release.
> > 
> > not only this one, but every commit for the past few years that fixed
> > bugs with security impact. for reference:
> > 
> > http://lwn.net/Articles/285438/
> > http://lwn.net/Articles/286263/
> > http://lwn.net/Articles/287339/
> > http://lwn.net/Articles/288473/
> 
> As I'm somewhere there is no web access, mind summarizing these if they
> are relevant?

they're very relevant and rather long, you should take your time and read
them whenever you're back on the normal net. or you can do like RMS and
surf the web through email ;).

> > what is the disclosure policy used for commits fixing bugs with security
> > impact (both vanilla and -stable, especially if there's a difference)?
> 
> What is outlined in Documentation/SecurityBugs.

so it's full disclosure for both vanilla and -stable, there's no difference?
just because at the end of your mail you say:

> > how does it relate to what is declared in Documentation/SecurityBugs?
> 
> That deals with how security bugs that are sent to security@kernel.org
> are handled, which is totally different from -stable releases, right?

now are they totally different or not? ;)

in any case, you say the full disclosure policy applies. what does that mean
for you? does it mean omitting security impact information you know about
(not 'here is a working exploit' but 'this is a buffer overflow' or 'this
is an exploitable bug')? because such omissions have repeatedly occured for
the past many years (you'll find several examples pointed out at those LWN
URLs) and they're hard to reconcile with your declared disclosure policy.

> > what do you include/omit?
> 
> Personally, I omit posting full "and here is explicitly how to exploit
> this problem" notices as that is foolish.

do you also omit any of the usual security related words, such as, say,
'buffer overflow', 'security' when describing a bug? say, look at today's
2.6.25.11 and its single fix that doesn't say anything about 'security',
heck, not even its announcement does. do you think it's what constitutes
full disclosure? ;)

> But also remember that -stable releases are just a compilation of
> patches that developers have sent to the stable developers, we use the
> original commit messages as published in the main kernel tree, except
> where the patch differs, which is rare.

you at least add CVE IDs on occasion, mainline commits are even worse in
that regard.

>  So it's not like these releases are any different than the main kernel
> releases on descriptions of patches and issues surrounding them. 

yes, the real and more important problem is with the mainline development
itself, you're mostly suffering collateral damage, so to speak. but since
you're also part of that development process, you can't hide behind that.

so guys (meaning not only Greg but Andrew, Linus, et al.), when will you
publicly explain why you're covering up security impact of bugs? and even
more importantly, when will you change your policy or bring your process
in line with what you declared?

cheers,
  PaX Team

