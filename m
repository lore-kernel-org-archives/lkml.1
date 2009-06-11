Return-Path: <linux-kernel-owner+w=401wt.eu-S1763211AbZFKLSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763211AbZFKLSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761355AbZFKLS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:18:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57956 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329AbZFKLS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:18:29 -0400
Date: Thu, 11 Jun 2009 13:18:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, ibm@android.com,
       swetland@google.com, san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611111823.GB7523@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610194852.GA28787@n2100.arm.linux.org.uk> <20090611.000219.206893038.davem@davemloft.net> <20090611073740.GB8592@elf.ucw.cz> <20090611103457.GG795@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611103457.GG795@n2100.arm.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 11:34:57, Russell King - ARM Linux wrote:
> On Thu, Jun 11, 2009 at 09:37:40AM +0200, Pavel Machek wrote:
> > On Thu 2009-06-11 00:02:19, David Miller wrote:
> > > From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> > > Date: Wed, 10 Jun 2009 20:48:52 +0100
> > > 
> > > > In short not as far as I know, and I'm very disappointed with the state
> > > > of affairs with google.
> > > 
> > > And of course, this whole android situation has absolutely nothing to
> > > do with how much of a pain in that ass you are to deal with as ARM
> > > maintainer.
> > 
> > Well, linux-arm-devel being subscribers-only and patch management
> > system that needs special headers certainly does not help here :-(.
> 
> That's got nothing to do with it.  You're just using that as an excuse
> to bash me with.

I believe it has something to do with it. linux-arm is effectively a
walled garden, away from lkml. Getting patches to linux-arm is more
interesting exercise than getting them to linux-i386. For trivial
patches, it matters.

> However, as a result of the complete lack of effort to update patches
> as a result of feedback coupled with my lack of bandwidth to review
> complex code implementing things like cross-bridge APIs (eg, ARM <->
> DSP communications channels), Brian basically gave up trying to get
> stuff into mainline.

> Now, ask yourself this question: why should I have to be the one to
> review things like ARM <-> DSP communication channel code?  Hint: I
> don't want to because I know nothing about the subject.  Where should
> I send these people to get such code reviewed?  No idea, there seems
> to be no one _anywhere_ who would seem to be interested in it.

I guess the patches should just go to lkml. If 

1) they don't mess up common code

2) google is willing to maintain them

3) they look mostly okay to interested parties on lkml

... I guess they should just go in. Maybe they should go into
drivers/dsp or drivers/mfd or something if you are not comfortable
having them in arch/arm.

They can certianly go to drivers/staging...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
