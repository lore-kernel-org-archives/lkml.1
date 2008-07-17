Return-Path: <linux-kernel-owner+w=401wt.eu-S932611AbYGQVI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbYGQVI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758784AbYGQVIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:08:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:7256 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbYGQVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PzhZbxttyQ8zN/6/hQVXaPvHXvrRI8IlrEbuKRaTT4YDNV3l1hrKkezYOxm9YWG8/W
         TkrLGyeMYo0GNX6VPiBA1rykfzWAL5eXCgz8rsxjebiOyNBob6UGQSl2T1qi0hrxG7HC
         KpbR9eTINdXY69CdcI2MGh+V7ejx0VgO1x1K0=
Message-ID: <c8b4dbe10807171408m1c8da2a4ga573f133d6beb86f@mail.gmail.com>
Date: Thu, 17 Jul 2008 22:08:47 +0100
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [stable] Linux 2.6.25.10
Cc: pageexec@freemail.hu, "Greg KH" <greg@kroah.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <alpine.LFD.1.10.0807150907480.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080703185727.GA12617@suse.de>
	 <487C242B.19490.17F690F7@pageexec.freemail.hu>
	 <alpine.LFD.1.10.0807141924020.3017@woody.linux-foundation.org>
	 <487CDEDD.21049.1ACFDAEA@pageexec.freemail.hu>
	 <alpine.LFD.1.10.0807150904290.3017@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807150907480.3017@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/08, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 15 Jul 2008, Linus Torvalds wrote:
>> 
>> So as far as I'm concerned, "disclosing" is the fixing of the bug. It's 
>> the "look at the source" approach.
>
> Btw, and you may not like this, since you are so focused on security, one 
> reason I refuse to bother with the whole security circus is that I think 
> it glorifies - and thus encourages - the wrong behavior.
>
> It makes "heroes" out of security people, as if the people who don't just 
> fix normal bugs aren't as important.
>
> In fact, all the boring normal bugs are _way_ more important, just because 
> there's a lot more of them. I don't think some spectacular security hole 
> should be glorified or cared about as being any more "special" than a 
> random spectacular crash due to bad locking.

I hate to state the obvious, but there's a reason security holes are treated differently - because they're *not* *obvious*. If a system is crashing spectacularly, generally someone notices and tries to fix it. On the other hand, security holes are usually invisible in normal operation until a hacker uses one to walk off with tens of thousands of people's credit card details. That's why there's so much effort put into tracking them.

> Security people are often the black-and-white kind of people that I can't 
> stand. I think the OpenBSD crowd is a bunch of masturbating monkeys, in 
> that they make such a big deal about concentrating on security to the 
> point where they pretty much admit that nothing else matters to them.
>
> To me, security is important. But it's no less important than everything 
> *else* that is also important!

True, there are other serious types of bugs (silent data corruption is one particularly nasty one). However, for *any* serious bug, it's important to be clear on what the likely impact is and what's affected. This goes particularly for the ones that might otherwise not be obvious to the person affected until it's too late, such as security and silent data corruption bugs, but really it applies to all serious bugs. I'm not convinced these descriptions are clear enough.

Aidan
