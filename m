Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZEKKr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZEKKr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZEKKrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:47:19 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33349 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZEKKrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:47:17 -0400
MIME-Version: 1.0
In-Reply-To: <m1pregmkld.fsf@fess.ebiederm.org>
References: <20090509143742.GA27663@kroah.com> <20090509161923.GA942@suse.de> 
	<20090509223454.4642753d.akpm@linux-foundation.org> <20090510152005.GA9461@suse.de> 
	<1241980263.9562.380.camel@laptop> <20090510221901.30c1c5a5@lxorguk.ukuu.org.uk> 
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com> 
	<20090510170016.1e3a4d97@infradead.org> <ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com> 
	<m1pregmkld.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 11 May 2009 12:46:57 +0200
Message-ID: <ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 04:36, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Devtmpfs is the simplest, is the fastest, is the most reliable, and it
>> is the most flexible
>
> FLEXIBLE?

Yes, flexible because you can do whatever you want in whatever order
and never run into problems with an empty /dev. You can even just
ignore /dev and go ahead. There are basically no dependencyies to do
other things in parallel.

>> option for us. And still, nobody will be forced
>> to use it, it's entirely optional. For our systems, we decided to do
>> it that way, and we ship it already in the distro, and if there are no
>> substantial problems coming up, which we don't expect, we will
>> continue using it.
>
> Yes but you are asking all of us to maintain it.  Forever in perpetuity.
> A better case needs to be made than you have already shipped the code.

I would be very careful with such statement if you want us to accept
your namespace hacks in the future. I guess if we ask with your next
round "do we want to to have to maintain this for forever" you get a
very different answer than today.

> I'm sorry you decided to ship the code before getting a review.  I
> guess that is the definition of an experimental feature.  One not in
> the upstream kernel.

No, I did decide to ship it in the distro which is how things work
since forever. And it's not in the upstream kernel now, while this
discussion happens.

>> You might not like it for whatever reason.
>
> I think your justification for this ``feature'' is strongly flawed.

I did not hear any substantial technical argument so far.

> You claim to save 2 seconds of a process that should take less than
> a tenth of a second.
>
> You claim flexibility while removing user space from the policy loop.

The made up numbers you are bringing up here, suggest that you never
worked in that area, and really, can you please talk about things you
have experience with, or get the needed one _before_ calling things
"flawed", "slow". You even suggest non-working racy hacks instead,
which is far from funny.

> You claim speed increases when comparing to a dog slow non-tuned
> implementation.

Again. nothing is dog-slow. We just don't do unreliable bad hacks like
you suggest. Have you ever wondered why _every_ distro does it this
way? Maybe they are all stupid and just wait for you to tell them and
solve their problem.

>> And we consider this problem as solved.
>
> What backroom have you had that discussion?

I wrote like ten times as many words as are in the patch, here in this
thread. I don't think there is any backroom here.

> You are presenting this as a decision already made.  I think you
> are not playing well with others.

Oh, like calling stuff "flawed", "dog-slow", while not even seen any
of this running for real?

> I don't see a case having been made that the existing user
> space interface is broken.  Just that the udev implementation
> is slow.

That's utter nonsense. It's not slow at all, it's just slower that
what we can do with the bit of help from the kernel.

> I think a slow user space application is simply not a justification
> for putting code in the kernel.

Can you read? Did you read the many reasons why we want this? I guess not.

> I think a developer using faulty arguments for their code likely
> has not thought things through and that is enough reason to call
> suspicion onto the code in my opinion.

You seem running in circles with searching for a "suspicion". Care to
provide a technical argument for the first time? That would be
appreciated.

Thanks,
Kay
