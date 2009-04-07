Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbZDGEtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbZDGEtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZDGEs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:48:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:21295 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZDGEsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:48:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RuaxPquPSZGPuT9q83jKZ4/oFgGzQ8FN1dm8UctnGlMSWGpk2/BJVmJLnXWWy9yHEz
         aOG09fGIuqsj/hDY43k+u5YyiUGHmWXQcHuEtx0pvnTZHtcVUqzEUMbHNEEEGmag8cOK
         ZfYgJF1O/oHsJlC7hrPy55yxtLaOjtqvJv8GY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904062120560.4010@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
	 <20090406151054.GD5178@kernel.dk>
	 <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>
	 <20090406183157.GD7376@mit.edu>
	 <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>
	 <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>
	 <1239076379.17426.23.camel@think.oraclecorp.com>
	 <9b1675090904062113r2bd2b209hea1061cc54a0b9c0@mail.gmail.com>
	 <alpine.LFD.2.00.0904062120560.4010@localhost.localdomain>
Date: Mon, 6 Apr 2009 22:48:53 -0600
Message-ID: <9b1675090904062148k7081be9bs26b5852d71a0a45c@mail.gmail.com>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Hua Zhong <hzhong@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 6, 2009 at 10:27 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 6 Apr 2009, Trenton D. Adams wrote:
>>
>> Okay, so a config option is a benefit in what way, for these
>> particular circumstances?  If someone wants to change the behaviour of
>> the kernel, for this particular case, they can just use tune2fs, no?
>
> Basically, I have a very simple policy in my kernel life:
>
>  - I don't touch distribution settings. I update the kernel, and NOTHING
>   else.
>
> (Ok, I lie. I do my own git version too, but I'm really unhappy when I
> feel like I need to maintain anything else)
>
> And I have that policy because quite frankly, if I start tuning distro
> settings, I'll
>
>  (a) forget about them and not do it on my next machine and
>  (b) do some magic that _I_ may know how to do but nobody else does, so
>     now what I'm doing is no longer relevant for anybody else
>  (c) I'm no longer helping anybody else.
>
> So I have a few bits and pieces that I develop (mainly the kernel but also
> git etc), and I don't make site-specific changes to them even if I could.
>
> In other words: if I make a change that helps me, I want to make sure
> that I make that option available to everybody else, because quite
> frankly that's a big portion of the whole point of open source.
>
> The whole "scratch your itch" isn't just about scratching _your_ itch,
> it's about getting it (almost by mistake) fixed for a lot of other people
> too.
>
>                        Linus
>

Interesting.  I suppose there is also the fact that every drive you
hook to the system would then have the kernel configured default.  So
that makes sense.  Otherwise it's 2, 5, 10, 20 tune2fs commands,
instead of one kernel config.

What about a procfs setting instead?  Is there a policy about why
something should be in procfs or /sys, or as a kernel config option?
That's basically as small as the patch you just made, right?

I'm just thinking that something like this, where people want one
thing or the other, but may not know it when they install Linux, might
like to change it realtime.  Especially if they are a Linux newbie,
and don't know how to compile their own kernel.  Or don't have time to
maintain their own kernel installs.
