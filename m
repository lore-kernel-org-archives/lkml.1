Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbXIPLa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbXIPLa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 07:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbXIPLav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 07:30:51 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1722 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbXIPLau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 07:30:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Date: Sun, 16 Sep 2007 13:30:25 +0200
User-Agent: KMail/1.9.7
Cc: Bernard Jungen <bern8817@euphonynet.be>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com> <1189865082.5271.91.camel@gaivota> <20070915165834.GA2054@euphonynet.be>
In-Reply-To: <20070915165834.GA2054@euphonynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709161330.25907.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 September 2007 18:58:34 Bernard Jungen wrote:
> On Sat, Sep 15, 2007 at 11:04:42AM -0300, Mauro Carvalho Chehab wrote:
> > With respect to your kernel-userspace API for xc3028, you made
> > something that seemed to be a dream: there's a consensus: not a
> > single developer believed that this is the better way; nobody seems
> > that this is the better approach.
> >
> > So, or you are the only media developer with good sense in the face
> > of the Earth, or you're incapable of understand the obvious: you're
> > wrong with this approach. IMO, the answer is quite obvious.
>
> Yes, as a newbie observer on the v4l list, the answer is obvious to
> me, at last, and the reason is not entirely technical. I can't read
> so many bogus arguments on so few lines without reacting.
>
> Rephrasing Mauro:
>
> "Not a single developer out of a few SEEMS to believe that it is the
> BETTER approach, so since the FEW represent ALL media developers in
> the world, and since there is only ONE RIGHT way to do things, and
> since the GROUP is always RIGHT and always knows better than the
> individual, then YOU're WRONG and I'm right. Conform to the group and
> do as the group says, whatever the consequences!"
>
> Geeks are decidedly as prone as others to blindly accept travelling
> on the slippery road of herd mentality and "obvious" conclusions
> based on appearances. Is this OPEN source development or a
> dictatorship or what?

It's called peer-review. It's why the linux kernel is as good as it is 
today. Yes, the tuner belongs in kernel-space. I'll use the user-space 
version from Markus in my ivtv driver as long as there is no 
alternative, but as soon as the same tuner is merged in the kernel I'll 
switch to that one. Why? Because the end-user shouldn't have to install 
a userspace daemon just to support a stupid little tuner.

I've said this before, and I'll say it again: the sole reason for this 
mess is personality clashes. Technically it should have gone in two 
years ago. I worked two years on getting the ivtv driver (and 
supporting i2c drivers) merged into the kernel, in the process of which 
many V4L2 (and a few DVB) API additions and refinements were made, all 
by working with the core developers. The end result was much better 
than if I would have done it all by myself.

It can be a difficult process (it's always hard to accept that the other 
person is right), and sometimes it means you have to sleep on it for a 
few nights before you realize that you are wrong and the other person 
is right. It can also go the other way, but even then it helps you 
because it forces you to express the technical reasons why you are 
right. And that gives you a better understanding of the issues at 
stake.

> So in the end Mauro will be right. And Markus will continue to
> develop and defend his stuff as HE sees fit. He knows his own work
> better than anyone else. It will be HIS way or nothing with his own
> stuff, it's his inalienable right.

You're never alone. You work within the kernel framework and within the 
v4l-dvb framework. You want to get something done, then you'll have to 
work together. The linux project is no different there then working for 
a company. And no, Mauro isn't always right. But just saying 'I'm 
right, you're wrong' never helps. Never, ever. Arguing your case based 
on technical arguments is the best way to go. Always remain respectful 
with whomever you're arguing, always remain polite.

The time for rational arguments in this situation has long since passed, 
unfortunately.

> And don't be naive, if there's no solution more viable than Markus'
> one, then the latter will eventually be widely adopted somehow,
> sometime, whatever the amount of grumbling from the establishment. No
> dictatorship/forced consensus can decide future's direction, nor
> improve its already low own viability.

Sigh.

	Hans
