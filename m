Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbYGPBrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbYGPBrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 21:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbYGPBrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 21:47:07 -0400
Received: from r00tworld.com ([212.85.137.21]:48631 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754AbYGPBrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 21:47:06 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Jul 2008 03:23:24 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487D69AC.21726.1CEE11F8@pageexec.freemail.hu>
In-reply-to: <alpine.LFD.1.10.0807151801280.2867@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D6344.18581.1CD50DA5@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151801280.2867@woody.linux-foundation.org>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 03:24:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jul 2008 at 18:08, Linus Torvalds wrote:

> On Wed, 16 Jul 2008, pageexec@freemail.hu wrote:
> > 
> > > And I take mostly the opposite view. I think pointing it out is
> > > actually likely to be counter-productive. 
> > 
> > you keep saying that, but you don't explain *why*.
> > 
> > > For example, the way I prefer to work is to have people send me and the 
> > > kernel list a patch for a fix, and then in the very next email send (in 
> > > private) an example exploit of the problem to the security mailing list 
> > > (and that one goes to the private security list just because we don't want 
> > > all the people at universities rushing in to test it). THAT is how things 
> > > should work.
> > 
> > fine with me, i wasn't talking about that at all though ;).
> 
> Oh, so now you're suddenly fine with not doing "full disclosure"?
> 
> Just a few emails ago you berated me for not doing full disclosure, but 
> now you're saying it is fine?
> 
> Can you now admit that it's a gray line, and that we just have very 
> different opinions of where the line is drawn?

you didn't pay attention to me very well. i said a few times in this
thread already that i did *not* care what disclosure policy you choose
for the kernel security bugs, that's none of my business. what i (and
many others) do care about is that you follow through that choice.

as it is, you supposedly practice full disclosure, whether you know what
that term means or not, it does mean something very specific for people
with a security background and you most certainly do *not* practice it.

*that* is what i was complaining about - inconsistency between your words
and actions. i even told you that you can solve it two ways: change one
or the other. that is, you can begin to practice full disclosure (or as
we figured it out slowly, some form of disclosure at least as what you
turned out to be doing can best be described as no disclosure or less
affectionately, coverup), *or* you can declare (=let the world know) that
you do *not* practice any disclosure, certainly not full disclosure at
least.

> > 1. simple words/phrases that one can grep for (mentally or automated)
> >    examples: 'security', 'exploitable', 'DoS', 'buffer overflow', etc
> 
> I literally draw the line at anything that is simply greppable for. If 
> it's not a very public security issue already, I don't want a simple "git 
> log + grep" to help find it.

fair enough, that's another way to say 'i cover them up'. at least we got
that out in the clear, thank you. you would have saved a lot of time if you
had declared this somewhere in the kernel docs. it's still not too late and
would be the prudent thing to do, there're *many* people living under the
assumption that you don't actually do this.

> That said, I don't _plan_ messages or obfuscate them, so "overflow" might 
> well be part of the message just because it simply describes the fix. So 
> I'm not claiming that the messages can never help somebody pinpoint 
> interesting commits to look at, I'm just also not at all interested in 
> doing so reliably.
> 
> > i believe 3-5 are definitely not commit message material. 1 or 2 are.
> > 5 should never be published or disseminated, 3 and 4 may be distributed
> > to interested parties.
> 
> And I believe you now at least understand the difference. I draw the line 
> between 0 and 1, where 0 is "explain the fix" - which is something that 
> any - and every - commit message should do.

yes, perfectly clear. as i said, the disclosure policy (whether you call it
that or not) is your choice. please make it public somewhere.

cheers and good night,
  PaX Team

