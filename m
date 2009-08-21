Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZHUTiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZHUTiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbZHUTix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:38:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49140 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658AbZHUTix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:38:53 -0400
Date: Fri, 21 Aug 2009 21:38:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       Kelly Bowa <kelly.bowa@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Atom processor inclusion
Message-ID: <20090821193841.GA5356@elte.hu>
References: <20090820130648.6e7236f7@titus> <20090820105029.GF29093@elte.hu> <200908201433.54785.tobias.doerffel@gmail.com> <4A8EE544.6020002@zytor.com> <4A8EE606.7000807@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8EE606.7000807@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> H. Peter Anvin wrote:
>> On 08/20/2009 05:33 AM, Tobias Doerffel wrote:
>>> Hi,
>>>
>>> Am Donnerstag, 20. August 2009 12:50:29 schrieb Ingo Molnar:
>>>> Yep, it looked acceptable - Tobias, do you have any
>>>> updates / latest version of that patch?
>>> No - it's still the improved version I posted at the end of May [1]. 
>>> The question is what to do with MODULE_PROC_FAMILY (CORE2 or ATOM) 
>>> and the mtune-
>>> fallback (generic, i686, ...)?
>>>
>>
>> Without benchmarks, we're flying blind on that one... although in
>> general, "generic" is probably best in the sense that it doesn't imply
>> that anything else has been done to it.
>>
>> As far as MODULE_PROC_FAMILY it really comes down to if we use movbe or
>> not, which I don't believe your patch does.  On the other hand, I really
>> think it's extremely unlikely that anyone will use modules compiled for
>> a different CPU, so I'm personally fine with changing that string.
>>
>> That whole mechanism is kind of broken, anyway.
>>
>
> personally, I would prefer it if we did a simple hash of the WHOLE 
> cflags, and put that into the module version string. Anything else 
> is just a weak, and useless, substitute for that.
>
> Using different CFLAGS in any shape or form should disqualify the 
> module as "incompatible".. and a simple hash is sufficient for 
> that.....

makes sense.

	Ingo
