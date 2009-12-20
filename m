Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZLTPhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZLTPhG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 10:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZLTPhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 10:37:05 -0500
Received: from smtp-out.google.com ([216.239.33.17]:39426 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZLTPhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 10:37:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=eL51JO5QWguT9+3HNetH8ZRhKj5VLSF9sc/Qy7Ot7y6tFpkeaVJoZlcWLb3iErh1L
	pe5zL2CHfsudFev3NnsoQ==
MIME-Version: 1.0
In-Reply-To: <1261322387.4314.22.camel@laptop>
References: <1261315437.4314.6.camel@laptop> <20091220144925.GA19608@elte.hu>
	 <1261320715.4314.9.camel@laptop>
	 <236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com>
	 <236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com>
	 <1261322387.4314.22.camel@laptop>
Date: Sun, 20 Dec 2009 07:36:56 -0800
Message-ID: <236ccac0912200736s48e19d20w17e7aa296b199945@mail.gmail.com>
Subject: Re: sched: restore sanity
From: San Mehat <san@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 7:19 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, 2009-12-20 at 07:05 -0800, San Mehat wrote:
>> >> Probably, but the rest is just as annoying, pr_* is crap.
>
>> Oh? Out of curiosity whats wrong with it?
>
> That's what should be asked of printk().
>
> And as long as we're not going to depricate printk() -- any attempt
> thereof will meet with fierce resistance from yours truly -- its all a
> futile exercise at best, and breaking scripts habits and patches at
> worst.
>
> I might be strange, but if I want to print something in C I write
> print[fk]() and be done with it, there's no reason what so ever to
> introduce fancy wankery for this.
>
> We try to stick to ANSI-C as much as possible, we've got
> kalloc,kfree,strcmp,strnlen and all the other 'regular' C bits,
> deviating from that serves no purpose but seed confusion.
>

Fair enough, thanks for the clarification.

-san

> If driver folks feel the need for dumb-ass wrappers because they can't
> write printk() then maybe, otoh if they can't do that, then wtf are they
> doing writing drivers anyway.
>
> But I feel this has no place in the core kernel at all, esp when its
> getting in the way of things without offering a single benefit.
>
>
>
>



-- 
----------
San Mehat
Staff Software Engineer
Google Inc.
o: 650-253-7422
c: 408-382-1249
san@google.com
