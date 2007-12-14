Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXLNRWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXLNRWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 12:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXLNRWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 12:22:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:21556 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbXLNRWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 12:22:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dBaa7ZKeFHr8VgG/57od2/vF/Dpz5hFxtJthq7GBNqFKpgJ8LHpyfohpKjHAmNDlUsQ6BeOsnAIU9f+zWF1XIvWCiA/T03VpdsFZ6B6TwSJp88H8ewsu7C9FAcFD8PyFi/mL8RyGiKreruPObgflZDUlWY/O6csLS3/pvmK+oj4=
Message-ID: <2c0942db0712140922wd008bd0r33bb888ab63c7c42@mail.gmail.com>
Date: Fri, 14 Dec 2007 09:22:26 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: stefano.brivio@polimi.it, "Linus Torvalds" <torvalds@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Daniel Walker" <dwalker@mvista.com>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       mbuesch@freenet.de, linux@bohmer.net, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
In-Reply-To: <200712141759.59273.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <2c0942db0712140827x38e5d971sbdb3d5864fc32364@mail.gmail.com>
	 <2c0942db0712140845p1dfd8b23va13525b75224f4c0@mail.gmail.com>
	 <200712141759.59273.mb@bu3sch.de>
X-Google-Sender-Auth: e7a094992a3d77db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 8:59 AM, Michael Buesch <mb@bu3sch.de> wrote:
> What if you want to compile your own kernel? Well, then you are on
> your own anyway. You have to track kernel changes anyway.

I'm trying to help you test your code before it goes out to the
unsuspecting masses. Do you think I do this for *fun*? Sheesh. No, fun
is leaving my system exactly as it is not putting my brain into ADD
(Attention Deficit Disorder) mode to track the latest rc and look for
bugs.

I'm trying to point out issues that are going to to come up once the
full release hits. Testing, you know? Because I guarantee you that I'm
a nicer and more competent tester than a lot of the people you'll have
to deal with if there's a bug. (I, at least, have been writing
software for 20+ years, and have been on all sides of the process.)

If you *don't* want testing of b43, then I'm happy to leave it alone
and go back to bcm43xx, and point out that it shouldn't be removed
from the tree. None of us want that, as bcm43xx is a pile of junk. (I
just tried rmmod'ing it twice. First time, it oopsed my system. I was
in X, so no backtrace, just a blinking caps lock LED. Second time was
a hard lock, no oops. Have I mentioned that I'm not doing this for
fun?)

> There are news sites (even not specific ones for the kernel)
> that reported the bcm43xx->b43 change weeks ago.

Perhaps so. It didn't hit kerneltrap or lwn, both of which I follow
via RSS, so not sure what I should have been looking at instead.

Regardless, I'm asking for three sentences to be added to the kernel
release announcement. Hell, maybe Linus would even *like* to have you
guys supply part of the release announcement. He's a nice guy, how
about we ask?

Look, this really isn't all that much about bcm43xx/b43 here. I'm
trying to say that there are things that can help get more testers. If
you don't care about that, then fine, ignore this message.

Ray
