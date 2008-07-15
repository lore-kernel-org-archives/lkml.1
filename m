Return-Path: <linux-kernel-owner+w=401wt.eu-S1762446AbYGOSG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446AbYGOSG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbYGOSGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:06:14 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:9704 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbYGOSGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding:from;
        b=VgdDlxYqLc8kj4hgiAYJW/6dW5fu+ECAcy9OxoecPhKDbnrxkN98Y7JQHhKv97kfIZ
         Ksn0qPqxd/J600g7y/Ve+aG8kRrtP9QL6PS22R7krY5wrINRYBb0PkX2xfpZlFDwgR7J
         4xqEC0a6GRfV8crq9suCYZJwN5x7rPxyc/W7g=
Message-ID: <487CE70B.9070506@greyfade.us>
Date: Tue, 15 Jul 2008 11:06:03 -0700
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>  <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com> <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
OpenPGP: id=1BB322F8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Charles grey wolf Banas <greyfade@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> 
> On Mon, 14 Jul 2008, Stoyan Gaydarov wrote:
>>> For example, I don't see any individual feature that would merit a jump
>>> from 2.x to 3.x or even from 2.6.x to 2.8.x. So maybe those version jumps
>>> should be done by a time-based model too - matching how we actually do
>>> releases anyway.
>> Does it have to be even numbers only?
> 
> No. But the even/odd thing is still so fresh in peoples memory (despite us 
> not having used it for years), and I think some projects aped us on it, so 
> if I didn't change the numbering setup, but just wanted to reset the minor 
> number, I'd probably jump from 2.6 to 2.8 just for historical reasons.
> 
> But I could also see the second number as being the "year", and 2008 would 
> get 2.8, and then next year I'd make the first release of 2009 be 2.9.1 
> (and probably avoid the ".0" just because it again has the connotations of 
> a "big new untested release", which is not true in a date-based numbering 
> scheme). And then 2010 would be 3.0.1 etc..
> 
It occurred to me that another approach might make sense:

Linux was released in 1991 with a 1.0 in 1994, correct? So, why not make
1991 sort of the Linux Epoch? The major number would be the decade since
Linux' release (this being the second decade of Linux, it works well)
and the minor number could be the year within that decade of releases.

I like this idea personally because it doesn't break the current
numbering scheme (2.7 is still skipped, though) and it can be
self-consistent for a number of years. When Linux reaches its fifth
decade and its midlife crisis, it'll be in version 5.0.

I don't know. That's my shed's color. :)

> Anyway, I have to say that I personally don't have any hugely strong 
> opinions on the numbering. I suspect others do, though, and I'm almost 
> certain that this is an absolutely _perfect_ "bikeshed-painting" subject 
> where thousands of people will be very passionate and send me their 
> opinions on why _their_ particular shed color is so much better.
> 
> The only thing I do know is that I agree that "big meaningless numbers" 
> are bad. "26" is already pretty big. As you point out, the 2.4.x series 
> has much bigger numbers yet.
> 
> And yes, something like "2008" is obviously numerically bigger, but has a 
> direct meaning and as such is possibly better than something arbitrary and 
> non-descriptive like "26".
> 
> Let the bike-shed-painting begin.
> 
> (I had planned on taking this up at the kernel summit, where the shed 
> painting is at least limited to a much smaller audience, but since you 
> asked..)
> 
> 			Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIfOcLi1yS1BuzIvgRAnW9AKCSBqFsctCS58XdZ81QdnSuMB4WpQCfbPTf
qTRm2dSF6OyvyTrN8cR4XzM=
=VcmW
-----END PGP SIGNATURE-----
