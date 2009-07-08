Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbZGHNC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbZGHNC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 09:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZGHNCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 09:02:50 -0400
Received: from mail.samba.org ([66.70.73.150]:48466 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZGHNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 09:02:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19028.39145.180869.603673@samba.org>
Date: Wed, 8 Jul 2009 23:02:33 +1000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <20090708130256.40957c3f@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<19028.31088.400461.939917@samba.org>
	<20090708130256.40957c3f@lxorguk.ukuu.org.uk>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

 > James reply was based on the fallacy that vendors will keep the source in
 > their tree. They don't do that *today*, look at their trees.

You keep talking about what is done about patents in other parts of
the free software world as though it is a good model to follow. It
isn't - it is a complete disaster.

The only weapon we have to fight patents right now is our collective
ability to find smart solutions to problems. The "every vendor for
themselves" approach that you seem to be so keen on makes that
collective approach pretty much impossible.

You talk about media players and other software being crippled in the
US and other countries as though this is a good thing. You talk about
vendors ripping out large slabs of functionality as though you want it
to happen.

I don't want that. I want to *fight*.

So how do we fight these and all the other patents that threaten
Linux? We implement the damn functionality anyway, finding a smart way
to make it work despite the patents. It has been so disheartening over
the years to see people say things like "oh, the XYZ codec is
patented, we can't use that". Patents don't work like that. They
patent very specific steps, and if you learn to read them properly
then you can find ways to get the functionality you need without just
applying an axe to a whole slab of useful features.

The patch I've posted is a good first step in showing the kernel
community how to do this. I'd like to see us apply the same approach
outside the kernel too. I'd like to see us produce implementations of
the 'patented' codecs that meet the same high standards for being
clearly non-infringing as the patch that I've posted for VFAT does.

I've been applying this approach in Samba for years, and it
*works*. Samba is extremely functional. We have not once had a user
complaint about a missing feature because of a patent workaround. How
do you reckon we achieved that? 

We, as a technical community, have the very best possible set of
resources for actually beating the patent system at its own game. Far
better than any company in the world by a very large margin.

We can also teach patent holders that filing a patent suit against the
Linux community is a _really_ bad idea. Patent holders will soon find
out that when they do that then there will quickly be a public
workaround to their patent posted. That public workaround can then be
used by not just the free software community, but also by the normal
proprietary vendors that these agressive patent holders make their
licensing money off.

So patent holders will learn that taking on the free software
community over patents loses them income from patent licensing. They
risk a huge, very talented, very motivated community of engineers
focussing its attention on their patent and finding a way around
it. They will learn that it is better to go after softer targets.

Short of a political miracle, that is the only way we are going to
beat the patent system. 

Let's stop whining about the unfair patent system and start fighting
back!

 > So why have the vendors not commented on list ? If they will want to
 > apply the patch why don't I see supporting email from them ?

I'm pretty sure you were at RedHat during a couple of patent
suits. What is the first thing that happened? I bet the lawyers told
everyone not to talk publicly about the patents.

That is standard practice within companies. How should we react to
that? We should react by helping them when they need the help. When we
need the help some day perhaps they will help us.

 > I can't comment on the advice I've seen directly, but I will point out
 > that every vendor I am aware of *removes completely* any source material
 > which they view with concern. You can download the packages and review
 > them if you doubt it.

oh yes, I've seen it, but unlike you I didn't jump with joy at the
sight of Linux users losing features because of the patent system. I
fumed at the fact that the vendors and projects involved did not have
the knowledge and skills to apply a more subtle, and much more
effective, approach to beating patents. 

We can teach each other those skills, and we can learn to beat
patents.

So please Alan, think about whether the approach that has been taken
for so long is working. Think about how it stops us using our brains
to solve problems that we're good at solving. Think about how much
worse things may get.

Then join me in trying to fight the patent system for real.

Cheers, Tridge
