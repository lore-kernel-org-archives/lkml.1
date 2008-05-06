Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbYEFNH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbYEFNH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYEFNHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:07:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35793 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbYEFNHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:07:19 -0400
Date: Tue, 6 May 2008 15:07:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andreas Mohr <andi@lisas.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.26-rc1
Message-ID: <20080506130701.GB2146@elte.hu>
References: <8287f540805041818g534c4e02qaadb0e749c5f3439@mail.gmail.com> <20080505053935.GA15734@rhlx01.hs-esslingen.de> <20080505073030.GI3350@elte.hu> <Pine.LNX.4.64.0805051601280.3218@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805051601280.3218@bombadil.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Hi Ingo,
>
> On Mon, 5 May 2008, Ingo Molnar wrote:
>
>>
>> * Andreas Mohr <andi@lisas.de> wrote:
>>
>>> Hi,
>>>
>>> probably related to the Alistair John Strachan media build breakage report:
>>
>>>   LD      arch/x86/kernel/built-in.o
>>>   LD      drivers/built-in.o
>>> ld: drivers/media/built-in.o: No such file: No such file or directory
>>> make[2]: *** [drivers/built-in.o] Error 1
>>
>> i reported and fixed that bug a week ago, see the "drivers/media build
>> fix for modular builds" patch on lkml.
>
> Thanks for your good work!
>
> I got several of your patches, and applied them on my tree. Not sure 
> if I got all ;)

i'm tracking these fixes (and a ton of other fixes) because it's needed 
by our tests, so will let you know if there's anything missing after the 
next video push+pull. Have a good second look at the Kconfig patches i 
did - Kconfig dependencies are a maze to figure out and debugging and 
sorting those out is not particularly straightforward to someone like me 
who just wants to do a hit-and-run fix.

	Ingo
