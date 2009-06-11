Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbZFKKfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbZFKKfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760519AbZFKKfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:35:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49725 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760364AbZFKKfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:35:09 -0400
Date: Thu, 11 Jun 2009 11:34:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, ibm@android.com,
       swetland@google.com, san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611103457.GG795@n2100.arm.linux.org.uk>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610194852.GA28787@n2100.arm.linux.org.uk> <20090611.000219.206893038.davem@davemloft.net> <20090611073740.GB8592@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611073740.GB8592@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 09:37:40AM +0200, Pavel Machek wrote:
> On Thu 2009-06-11 00:02:19, David Miller wrote:
> > From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> > Date: Wed, 10 Jun 2009 20:48:52 +0100
> > 
> > > In short not as far as I know, and I'm very disappointed with the state
> > > of affairs with google.
> > 
> > And of course, this whole android situation has absolutely nothing to
> > do with how much of a pain in that ass you are to deal with as ARM
> > maintainer.
> 
> Well, linux-arm-devel being subscribers-only and patch management
> system that needs special headers certainly does not help here :-(.

That's got nothing to do with it.  You're just using that as an excuse
to bash me with.

The real problem with android is that their efforts to mainline the code
are very sparse - I seem to recollect that there were two attempts about
a year or more apart, the first of which was relatively painless and the
second which was more problematical (partly caused because they'd left
it soo long since the last submission.)

Around the time of their second submission, someone who used to be more
active in the ARM community started making accusations against Google
for "throwing their code over the wall and disappearing" and "claiming
that their code is on kernel.org now".  They went on to say (and I'm
quoting) "i don't think they give a shit about what you or i have to
say about it".

Having dealt with Brian's kernel submissions and provided feedback on
them, I took issue with those comments because that wasn't how I (or even
akpm) saw the situation.  The result of that was the person making those
accusations fell out with me.

However, as a result of the complete lack of effort to update patches
as a result of feedback coupled with my lack of bandwidth to review
complex code implementing things like cross-bridge APIs (eg, ARM <->
DSP communications channels), Brian basically gave up trying to get
stuff into mainline.

Now, ask yourself this question: why should I have to be the one to
review things like ARM <-> DSP communication channel code?  Hint: I
don't want to because I know nothing about the subject.  Where should
I send these people to get such code reviewed?  No idea, there seems
to be no one _anywhere_ who would seem to be interested in it.

Andrew tried to resolve this review problem by getting some co-operation
between various members of the ARM community - so that two or three
people with large code bases would do mutual reviews and gain from
each others efforts.  The result of that was... precisely nothing.  No
interest in lifting a finger to help someone else.

So, to go pointing blame at various things you don't like is not only
naieve but down right idiotic and stupid.  I suggest you stop your
personal (and as demonstrated in other emails to me over your Zaurus
problems) persistent rmk bashing agenda and wake up to reality.

And now think whether you are part of the problem - when you load me up
with your Zaurus problems, a platform which I know precisely zilch about,
and I have to waste time fighting tooth and nail to get you to talk to
people who might be able to help you.
