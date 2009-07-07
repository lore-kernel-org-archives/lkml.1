Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbZGGPui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbZGGPui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZGGPu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:50:27 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:34899 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbZGGPu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SnL5+J6GFYwcwqiAEZG3Q3R0beDwnUhIiklFtBsGau9TVLRaOY5PmUfjJlXpVcTCnU
         tULkRxx/c3GVu41ZVKCoKiLJndmLHFvwghOtuZuyQ1kiznjEKLY1+vGXhFs5H6I1lPF0
         zf11WiRbj0RCbISV1mIUu4SGzRdEngoeCsJSY=
MIME-Version: 1.0
In-Reply-To: <1246981444.9777.11.camel@twins>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com> 
	<1246980836.9777.5.camel@twins> <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com> 
	<1246981444.9777.11.camel@twins>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, 7 Jul 2009 16:50:04 +0100
Message-ID: <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com>
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 7, 2009 at 4:44 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Tue, 2009-07-07 at 16:38 +0100, Joao Correia wrote:
>> On Tue, Jul 7, 2009 at 4:33 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
>> > On Tue, 2009-07-07 at 16:25 +0100, Joao Correia wrote:
>> >> (Applies to current Linus tree, as of 2.6.31-rc2)
>> >>
>> >> As it stands now, the limit is too low and is being hit by false
>> >> positives. Increasing its value will allow for more room to work with.
>> >>
>> >> This was suggested by Ingo Molnar
>> >> (http://article.gmane.org/gmane.linux.kernel/852005) but never
>> >> submitted as a patch, to the best of my knowledge.
>> >
>> > Right, we found a bug in the dma-debug code that generated tons of
>> > classes where only 1 was needed, which in turn generated tons of chains
>> > and stack entries.
>> >
>> > But that got merged, but you're seeing more of this?
>
>> Yes. Anything 2.6.31 forward triggers this immediatly during init
>> process, at random places.
>
> Not on my machines it doesn't.. so I suspect its something weird in
> your .config or maybe due to some hardware you have that I don't that
> triggers different drivers or somesuch.
>
>
>

I am not the only one reporting this, and it happens, for example,
with a stock .config from a Fedora 11 install.

It may, of course, be a funny driver interaction yes, but other than
stripping the box piece by piece, how would one go about debugging
this otherwise?

Joao Correia
