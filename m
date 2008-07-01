Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbYGAMS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbYGAMS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbYGAMRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:17:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:58040 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774AbYGAMRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:17:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TdUH3rpWRlLmAFUZ2YqDDKpb26NnFXxgjWD0ftwxGBdkoAzXEeCen6oj4GReMeq2qB
         em/UybTDTjWylFpDq3S+PvBZtb47RQ9ugAglC2SsIsPmClivLz/R9oPQCVzJUfrHykTN
         zAZirzszVTb8JfrHRW9JvubIVzm9v3aFwK1GI=
Message-ID: <19f34abd0807010517w6e2003d6j86922df0aa0052ac@mail.gmail.com>
Date: Tue, 1 Jul 2008 14:17:48 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: kmemcheck detected possible information leak to userspace?
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <87skutu8pw.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807010216k11a60382xf7a27b4b27f0819@mail.gmail.com>
	 <20080701102459.GB30248@2ka.mipt.ru>
	 <19f34abd0807010352t264fda16g826912a857e88140@mail.gmail.com>
	 <87skutu8pw.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 1:47 PM, Andi Kleen <andi@firstfloor.org> wrote:
> "Vegard Nossum" <vegard.nossum@gmail.com> writes:
>
>> But there is one thing I forgot: Is this memory initialized by DMA? If
>> so, the warning is bogus and I will go hide in shame.
>
> Yes it is.
>
> [btw that was something I noted during the initial review and was then
> ridiculed for]

I just went back and reviewed the original thread. (I assume you're
talking about the kmemcheck v3 thread,
http://lkml.org/lkml/2008/2/7/500.)

I'm sorry about having forgotten this particular comment you made.
Please take into account that before December last year, I didn't even
know what an skbuff was. And I didn't know how DMA worked. There can
be a lot of things that slip past when I don't have the basic mental
hooks on which to hang them. (Though, I must say, those discussions
have taught me a lot.) There was also the fact that Ingo for a long
time carried patches to silence these warnings, but which were dropped
before the 2.6.26 merge window because they should go through the
right maintainers instead of the x86 tree. I forgot about it, so I've
made a mistake this time.

But I don't see that you were ever ridiculed. In fact, I am only
grateful for all the comments you've made, and the help you've been.


Vegard

PS: The error I just reported was different from the ones we've had
before, which is why I didn't recognize it immediately.

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
