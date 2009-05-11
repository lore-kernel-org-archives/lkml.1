Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZEKLf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZEKLf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZEKLfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:35:14 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38159 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbZEKLfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:35:12 -0400
MIME-Version: 1.0
In-Reply-To: <20090511115504.568c9a92@lxorguk.ukuu.org.uk>
References: <20090509143742.GA27663@kroah.com> <20090510152005.GA9461@suse.de> 
	<1241980263.9562.380.camel@laptop> <20090510221901.30c1c5a5@lxorguk.ukuu.org.uk> 
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com> 
	<20090510170016.1e3a4d97@infradead.org> <ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com> 
	<m1pregmkld.fsf@fess.ebiederm.org> <ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com> 
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 11 May 2009 13:34:52 +0200
Message-ID: <ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 12:55, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> You've yet to demonstrate
> - That your patches are a real speed up

And I did, and it's obvious that creating a single file along with the
~10 we already create in /sys, instead of running through /sys or
/proc later and reconstruct what we missed, is always, and in every
case faster and simpler. It gets rid of a bunch of things we need to
do today, and depending how much of the things you remove, you get
faster. It's a different model and hard to compare directly. But for a
fact, you can never be faster than the kernel provided nodes.

> - That dumping more crap in kernel without policy and management is a
>  good idea

What exactly do you find is "crap"? What do you mean with "management"?

> - That the other proposals are worse than yours.

I also did, in exactly this thread.

> Arjan produced detailed boot graphs and boots a box very fast indeed. I
> see no boot graphs, no detailed analysis here.

I did in a reply to your earlier mail. And also mentioned the
init=/bin/sh case, which I think, would be reason enough alone,
without all the other gains, to do that.

> Instead we have obnoxious threats to Eric Biederman and an "I am going to
> ram this into the kernel whatever" approach.

Nobody says such thing. I just defend against "dog-slow", "backroom",
and the proposal of even more broken hacks to solve this very problem.
There is no hammering at all, it's just my personal discomfort with
replies who ignore the real issues, and bring up false facts.

> Neither are constructive or useful and this isn't the way the Linux
> kernel project works.

You might be right here, I don't disagree. It's becoming more a
personal issue than a technical, and sorry for that. But stuff like
this happens sometimes, and it's also sometimes "how the kernel
project works". :) Again, sorry.

> Yes maybe you can stuff things into Greg's tree
> easily because you both work for SuSE but that isn't the right way to do
> stuff for upstream.

Come on. You can not convince Greg about anything, just because you
happen to work for the same company. Many of us share a company with
others, also you did in the past and you do now - and we will get
nowhere bringing up such conspiracy statements.

We came up with this, because we think it is the right thing, and it
has proven to solve our problems, and I'm personally still convinced
it is the best option, that's all.

Thanks,
Kay
