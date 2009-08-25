Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbZHYTNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbZHYTNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbZHYTNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:13:45 -0400
Received: from slowhand.arndnet.de ([88.198.19.76]:55521 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754680AbZHYTNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:13:44 -0400
Message-ID: <4A9437E4.4060609@nets.rwth-aachen.de>
Date: Tue, 25 Aug 2009 21:13:40 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
References: <4A9407B1.6020400@nets.rwth-aachen.de> <84144f020908250929t7d4a74f1n4827de04e5c4c56a@mail.gmail.com> <4A94161A.2020609@nets.rwth-aachen.de> <1251219129.4852.1.camel@penberg-laptop> <4A94242E.30309@nets.rwth-aachen.de> <1251223399.13451.5.camel@penberg-laptop> <4A942BDD.70303@nets.rwth-aachen.de> <1251226720.13451.15.camel@penberg-laptop> <1251227271.13451.16.camel@penberg-laptop>
In-Reply-To: <1251227271.13451.16.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Tue, 2009-08-25 at 21:58 +0300, Pekka Enberg wrote:
>> On Tue, 2009-08-25 at 20:22 +0200, Arnd Hannemann wrote:
>>> Pekka Enberg wrote:
>>>> On Tue, 2009-08-25 at 19:49 +0200, Arnd Hannemann wrote:
>>>>> Hi Pekka,
>>>>>
>>>>> Pekka Enberg wrote:
>>>>>> On Tue, 2009-08-25 at 18:49 +0200, Arnd Hannemann wrote:
>>>>>>>> Thanks for doing the bisect! Can we also see your
>>>>>>>> .config also?
>>>>>>> Config for -rc7 is attached. My bisect configs were based
>>>>>>> on that
>>>>>> Thanks! While we wait for the Xen people, you can try the
>>>>>> following patch to see if we can narrow the bug down to
>>>>>> trap_init().
>>>>> Yes seems to be trap_init(). -rc7 with this patch applied
>>>>> boots up to the prompt.
>>>> Thanks for testing! Ingo, what do you think of the following
>>>> patch? AFAICT, x86-32 is the only architecture playing with
>>>> traps in mem_init() so this should be the safest fix for
>>>> 2.6.31.
>>> Hmm, -rc7 + this fix does not work for me :-/ Still hangs before
>>> any output...
>> Arnd, does this work for you?
>
> Here's a version of the patch that actually compiles. :-)

Great, this actually works, too :-)
Boots up to the prompt.

Best regards,
Arnd


