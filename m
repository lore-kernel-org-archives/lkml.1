Return-Path: <linux-kernel-owner+w=401wt.eu-S933564AbXG2Smc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564AbXG2Smc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 14:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765122AbXG2SmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 14:42:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46455 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764336AbXG2SmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 14:42:22 -0400
Date: Mon, 30 Jul 2007 00:24:35 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Martin Steigerwald <Martin@lichtvoll.de>
cc: ck@vds.kolivas.org, Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       lkml@metanurb.dk
Subject: Re: [ck] Re: Linus 2.6.23-rc1
In-Reply-To: <200707292023.36555.Martin@lichtvoll.de>
Message-ID: <alpine.LFD.0.999.0707300008230.30928@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <200707291256.32769.Martin@lichtvoll.de> <20070729174239.GA20399@uranus.ravnborg.org>
 (sfid-20070729_201124_376072_B6A6B3E0)
 <200707292023.36555.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,


On Sun, 29 Jul 2007, Martin Steigerwald wrote:

> Am Sonntag 29 Juli 2007 schrieb Sam Ravnborg:
> > On Sun, Jul 29, 2007 at 12:56:28PM +0200, Martin Steigerwald wrote:
> > > Am Sonntag 29 Juli 2007 schrieb Sam Ravnborg:
> > > > > I
> > > > > actually also think that the communication between Ingo and Con
> > > > > could have been better especially when Ingo decided to write CFS
> > > > > while Con was still working hard on SD.
> > > >
> > > > You realize that Ingo posted his code for anyone to look at/comment
> > > > at about 48 hours after he started to work on CFS?
> > >
> > > Yes.
> >
> > So whats wrong then?
> > Ingo decides to do a better scheduler - to some extent inspired by
> > Con's work. And after 48 hours he publish first version that _anyone_
> > can see and comment on. Whats wrong with that?
> >
> > Did you expect some lengthy discussion before the coding phase started
> > or what?
> >
> > Just trying to understand what you are arguing about.
> 
> If I tried to rewrite a kernel subsystem - should I ever happen to dig 
> that deep into kernel matters - while I actually know that someone 
> already spent countless hours on exactly rewriting the exact same 
> subsystem, I think I would have told that other developer about it as 
> soon as I started coding on it. And if it just was a
> 
> "Hi Con,
> 
> I reconsidered the scheduling ideas again you brought to the Linux kernel 
> world. Instead of using your scheduler tough I like to try to write a new 
> one with fairness in mind, cause I think this, this and this can be 
> improved upon.
> 
> I would like to hear your ideas about that as soon as possible and would 
> like you to contribute your ideas and also code, where you see hit. You 
> can find the git / bazaar / whatever repository where I do my 
> developments at: someurl.
> 
> Regards, Ingo"

Sending out the code (and early enough, 48 hours /is/ early enough) *is*
the normal (and good) way to do exactly the communication you described
above, IMHO.

> I believe that Ingo did not meant any bad at all. I think its just the way 
> he works, he likes to have code before saying anything. But still I 
> believe before I'd go about replacing someone else code completely I 
> would inform that developer beforehand, even if it then turns out not to 
> be feasible at all. No need to anounce it to the world already, but I 
> would have informed that developer.

IMHO, what you're suggesting is: (1) not the way development normally
happens in Linux, and, (2) not the way it /should/ happen, either. If
there's something (subsystem, any code big or small) I think I can do
better or have an idea for, I /should/ be able to just hack on it a bit
and then send it out so everybody can comment on it. Why should I be
forced to dance/discuss around with some other people, when the faster
and more effective way would be just present the code/patch that I
have in my mind as an RFC?

See, Martin, in the end it's not about developer A vs developer B. It's
about making the kernel the best out there -- that's what the users want,
anyway. Yes, I fully understand (and have said so earlier myself) that
there's a very important "social" aspect to development on such projects,
but it's best if developer B understands that this is the way things do
(and should) happen and adapt to it. [ It's not like I've been around for
long, however, but the above is still my opinion, fwiw. ]

Satyam
