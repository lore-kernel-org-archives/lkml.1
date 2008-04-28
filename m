Return-Path: <linux-kernel-owner+w=401wt.eu-S937182AbYD1Q61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937182AbYD1Q61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934185AbYD1Q6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:58:18 -0400
Received: from saeurebad.de ([85.214.36.134]:58609 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934001AbYD1Q6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:58:17 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [git pull] "big box" x86 changes, bootmem/sparsemem
References: <20080426185516.GA32364@elte.hu>
	<alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
	<20080426194143.GA8366@elte.hu> <87hcdmnccu.fsf@saeurebad.de>
	<86802c440804271733o1ec17f7aye04216ce28347435@mail.gmail.com>
Date: Mon, 28 Apr 2008 18:58:14 +0200
In-Reply-To: <86802c440804271733o1ec17f7aye04216ce28347435@mail.gmail.com>
	(Yinghai Lu's message of "Sun, 27 Apr 2008 17:33:50 -0700")
Message-ID: <87k5ih6hnd.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Sun, Apr 27, 2008 at 3:48 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
>> Hi Ingo,
>>
>>
>>  Ingo Molnar <mingo@elte.hu> writes:
>>
>>  > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>  >
>>  >> IOW, they'd be big enough that people hopefully don't start nitpicking
>>  >> about some *totally* uninteresting small detail, but small enough that
>>  >> people can read it through without losing concentration about a
>>  >> quarter of the way in.
>>  >
>>  > ok. Here's the "memory management" type of changes:
>>  >
>>  >    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-bigbox-bootmem.git for-linus
>>  >
>>  > the other sub-trees will depend on these changes. I think these
>>  > infrastructure and other improvements are mergable and pullable as-is.
>>  >
>>  >       Ingo
>>  >
>>  > ------------------>
>>
>>  [...]
>>
>>
>>  >       mm: allow reserve_bootmem() cross nodes
>>
>>  I find it sad that this goes in now.  I wrote a clean version of
>>  reserve_bootmem() [1] and it was rejected with arguments that I did not
>>  understand [2] and that were not further explained even though I asked
>>  for it [3].
>>
>>  http://lkml.org/lkml/2008/4/16/76
>>  http://lkml.org/lkml/2008/4/16/234
>>  http://lkml.org/lkml/2008/4/16/250
>>
>>  Your comment was rather unfair, because it gave the impression you did
>>  not read the thread before replying.  And you did not react to other
>>  explicit questions from me.  If you find my patches to be crap, say so
>>  and please explain WHY so I have a chance to improve.
>
> this thread is for reserve_bootmem ?

Sorry, my mistake.  I was referring to

5a982cbc7b3fe6cf72266f319286f29963c71b9e: mm: fix boundary checking in
free_bootmem_core

	Hannes
