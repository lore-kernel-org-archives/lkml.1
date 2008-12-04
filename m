Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYLDDz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYLDDz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 22:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYLDDzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 22:55:51 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:60078 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYLDDzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 22:55:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MU18VnpJloujxtaJ4dxk6a0uLdf3h9pgk0wGrdz32A/vYwgmorBBD7jNHh7r0SIhzA
         WLrTThn0zLbuu9fupsUvui5pMm5NUDY9cBbJpu+Xfw3qnHqbuT7nunLzFHdk2TdVHAiC
         /A/hqAtaTsE0SgZJ9/sh8FUT+ohBKCPKBcUK0=
Message-ID: <8bd0f97a0812031955y5ab713baj3e9351816343d33a@mail.gmail.com>
Date: Wed, 3 Dec 2008 22:55:48 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: Yet more ARM breakage in linux-next
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, "Stephen Rothwell" <sfr@canb.auug.org.au>
In-Reply-To: <200812041245.24568.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081203192905.GA12502@flint.arm.linux.org.uk>
	 <200812040952.44957.rusty@rustcorp.com.au>
	 <8bd0f97a0812031733n18184927m2b4fcfa0ed05cd7b@mail.gmail.com>
	 <200812041245.24568.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 21:15, Rusty Russell wrote:
> On Thursday 04 December 2008 12:03:57 Mike Frysinger wrote:
>> On Wed, Dec 3, 2008 at 18:22, Rusty Russell wrote:
>> > On Thursday 04 December 2008 07:11:09 Andrew Morton wrote:
>> >> On Wed, 3 Dec 2008 19:29:05 +0000
>> >>
>> >> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
>> >> > This seems to be causing lots of ARM breakage:
>> >> >
>> >> > lib/find_next_bit.c:183: error: implicit declaration of function
>> >> > '__fls'
>> >> >
>> >> > Whoever's responsible,
>> >>
>> >> git-blame?
>> >
>> > It's me.  Turns out sparc, avr32 and arm all don't define __fls in their
>> > asm/bitops.h, and I'm the first one to use it in generic code.
>>
>> the Blackfin port also does not ... you going to post a change for
>> that since the build breaks for Blackfin atm too ?
>
> Sure, why not join the party!
>
> (Hmm, maybe I should change that list to a shorter list of archs which
> *do* define __fls?)
>
> blackfin: define __fls
>
> Like fls, but can't be handed 0 and returns the bit number.
>
> (I broke this arch in linux-next by using __fls in generic code).
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

cheers
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
