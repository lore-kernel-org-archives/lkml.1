Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbXIMONQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbXIMONQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXIMONA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:13:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:19740 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbXIMOM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:12:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T4HvLouxvWtTQevWZhsEyH5I75MdBUETozu9BYk8jHqYA0t1mY0NOyBjerOVg35FeHpfVssDGqCCDs9J3i8STDjXTlVBBA/TSQksS6xQvXreV6hA73/IUFusOV7POZvg34rvE7WuYMQ5TFLcQky5fIm8HJzNP3RwCZkhv+cdhEI=
Message-ID: <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>
Date: Thu, 13 Sep 2007 16:12:58 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Johannes Stezenbach" <js@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       video4linux-list@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070913131353.GB26972@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C1BCC5.9090709@amd.com> <1189626560.5160.57.camel@gaivota>
	 <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
	 <20070913131353.GB26972@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On 9/13/07, Johannes Stezenbach <js@linuxtv.org> wrote:
> On Thu, Sep 13, 2007, Markus Rechberger wrote:
> > Let's add the LKML to this.
> > 
> > On 9/13/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> > > On 9/12/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > > > I don't see any technical reason why tuner drivers should be moved to
> > > > userspace. Looking at xc3028 device, the driver is very simple and
> > > > doesn't require any special treatment that it isn't possible to be
> done
> > > > at kernel. There are already some implementations on kernelspace that
> > > > works fine.
> > >
> > > As from my side to support the xceive driver properly it needs a
> > > rewrite and a proper API description. Since it's not possible to
> > > discuss any API changes
> 
> Not possible? We're doing it all the time...
> 

Then ask Mauro about the audio standard discussion which I had with him.

> However, your ideas were rejected in this discussion,
> and you can't seem to get over it.
> 

As for future projects I see other people having the same problems if
they want to join the project. If deeper requirements and/or ideas will
come up some particular people will try to run their own game.
If I'm doing something wrong technically then state it out show me
the bugs that I can understand what I did wrong or what I am doing
wrong. As for design changes if someone thinks he has to deny 
something he has to state out _why_ and not only some overall
nontechnical statements which do not help anyone.

> > > don't get me wrong but the existing community is rather small and
> > > kicking off people who are interested in changing things.
> 
> IMHO there is a lack of openness caused by people being burned
> in past flamewars. This makes it a bit difficult to see through
> what happens and why, and to participate.  However, I think it
> is completely wrong to say that the community is "kicking off people".
> 

You identified it already the right way in one mail much earlier. It's a
messup caused by many people and not only by one single person.
And that's also how I see it.

> > > I'm against how the project works out at the moment and how it worked
> > > out in history. Exactly this way will kick off companies to be
> > > interested in future like Avermedia. A driver can easily be written
> > > within a few weeks and I've been struggling with it for 2 years(!!!)
> > > now just for nothing finally telling me that some guys want to steal
> > > my code and move it to kernelspace although it would raise more
> > > complications with upcoming and current devices which have even more
> > > requirements.
> 
> Oh dear, there we go again... more flame bait...
> 
> I reality, 95% of your driver code could have been merged
> without problems, but you refused to take the small, objectionable
> part out of the picture.
> 

the driver itself still evolves, so the main point is in getting those incomplete
APIs to support further requirements. Instead of acknowlidging and seriously
discussing the solutions of others all that's beeing done now is to redo things
hundred times and splitting development one side beeing more open (which
is the userspace work) and the other part beeing more closed to a few people 
only (the inkernel work).
It's not my task to convince myself to rewrite the base of something which
I don't think that it would be valueable. The one who wants me that I 
spend days in changing my code should try to convince me to change
my mind on that, unless he can provide patches which demonstrate
that his changes are definitelly an advantage over what has been done 
from my side. 
I will for sure acknowlidge everything that will seriously improve the work 
which has been done.

> (For those interested:
> http://mcentral.de/~mrec/patches/v4l-dvb/hg_v4l-dvb-experimental_01.patch
> The patch changed the internal tuner API and required changes
> to all tuner drivers.)
> 

The main problem is moreover that the RFC didn't get discussed properly, afterwards people wondered what happened, even though the sources
were also available all the time in a public repository.

> Your all-or-nothing approach didn't work out.
> 

well we got far enough that I end up to step away and preparing the sources
to be able to get submitted beside linuxtv since I don't/didn't get any useful
technical feedback there.
Convince me that my work is welcome then I might start to submit smaller
patches, I already spent days for exporting patches in history and it all
end up nowhere but in unfriendly discussions - which also turned me to be
unfriendly to some people (which I've been told that I should ignore them 
recently and also not continue to to argue on a nontechnical level .. althought 
as mentioned I'm not the only one who made mistakes :-)

> Out of curiosity: How does your userspace approach solve
> the hybrid (analog/digital TV) tuner problem which was the
> only objectionable part of your work? And why are the kernel
> parts of your new interface now less objectionable? What changed?
> 

It's only a step in development, I do not intend to keep the kernel
stub in the end, but I do intend to keep and use the userspace drivers
with i2c-dev in the long run, this requires a v4l/dvb library at the front
of everything. Till such a library shows up I plan to use the 
kernelspace-userspace stub.
 
They are less objectionable because it adds a wrapper into the
subsystem which it didn't do before, the previous approach merged 
the structs and further work would have been focussed on getting it 
merged even better.

Markus
