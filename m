Return-Path: <linux-kernel-owner+w=401wt.eu-S1763374AbYEVAfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763374AbYEVAfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937636AbYEVAeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:34:37 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:42615 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936924AbYEVAef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gBb8mJdrinR0PoK1PL4PiJUqP1uZuUROU0jxk8pKAXO9PE+UYYpldZz0QBzsTYVpWGlE7pHltddyX51ieil/N9LThkmEi6IBdenQS0dgRbXlmCfTt0HSEHBsy4YdoddqiZm2dO8gynfnCR9DPBKruh6LTEUGvz4mG5Hg82jDmaw=
Message-ID: <9a8748490805211734v263a1d01xd71ac72d638ec826@mail.gmail.com>
Date: Thu, 22 May 2008 02:34:32 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard indentation of arguments)
Cc: "Jonathan Corbet" <corbet@lwn.net>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
       rdunlap@xenotime.net, tytso@mit.edu, hch@infradead.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080522001412.GS28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490805211306l50b8411ax4462be18c94ca065@mail.gmail.com>
	 <32279.1211401651@vena.lwn.net>
	 <9a8748490805211337q1e7ceab7i80e4820c46f8171b@mail.gmail.com>
	 <9a8748490805211646s5ef93f8ey43ebbc7746fb1a3b@mail.gmail.com>
	 <20080522001412.GS28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/22 Al Viro <viro@zeniv.linux.org.uk>:
> On Thu, May 22, 2008 at 01:46:28AM +0200, Jesper Juhl wrote:
>
> 0.  Use your common sense.  No hard rules will ever replace that.
>
>> - Sign up with Coverity (http://www.coverity.com/) to get access to
>> the results of their regular runs of Coverity Prevent against the
>> kernel source. Their static analysis of the kernel source finds many
>> bugs that need fixing. There is lots of good work there that needs
>> doing.
>>
>> Naturally there's also other work that can be done, like writing a
>> driver for some, currently unsupported, hardware etc, but its probably
>> best to get your feet wet with some bug fixing first.
>
> If you are familiar with C, reading the kernel source (e.g. starting
> at system call and going down from there) can be very useful; you will
> need such skills anyway and you might actually find real bugs.
>
> Asking the questions along the lines "code seems to assume that <this> never
> happens; why can't it happen and what happens if it does?" is generally
> welcome, assuming that question is more or less coherent.  "I do not
> understand this code at all" will be less useful and "<this> is <expletives>
> BROKEN!!!  I've found a major hole!!!" would better be right - which is not
> impossible.  Use common sense; if you turn out to be wrong (which is also
> quite possible), the size of crow you'll have to eat will be directly
> proportional to the vehemence of the original posting.  That applies to all
> of us - pretty much everyone had been there and probably will be there again
> and again.  On the other hand, do not be surprised if the answer will be
> "It's because...  Umm...  Oh, !@#!@#, looks like you've spotted a nasty hole".
> It also happens and assuming that code is correct just because it is in the
> tree is a bad mistake.  Newbies can and do find serious bugs and doing that
> can earn one a lot of good will.
>
>> Try to stay away from doing pointless work, like just fixing up the
>> coding style in a file, reformatting comments etc - it's not worth the
>> effort and your patch is likely to be rejected. Fixing up incorrect
>> comments to be correct, fixing up references to removed or renamed
>> functions/arguments etc is, however, useful and worth doing.
>
> Note that fixing up coding style in the code you are modifying is fine,
> provided that coding style part does not obscure the real changes you
> are making and the scale of coding style changes is not wildly out of
> proportion.  Again, use the common sense - changing two lines in a function
> is not a reason to reformat every file in directory while you are at it.
>

Thanks a lot for your comments Al.
I'll try to incorporate most of it in the next revision of the document.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
