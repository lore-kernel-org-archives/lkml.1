Return-Path: <linux-kernel-owner+w=401wt.eu-S1764385AbYD1AT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764385AbYD1AT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYD1ATT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:19:19 -0400
Received: from saeurebad.de ([85.214.36.134]:48737 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbYD1ATT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:19:19 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [git pull] "big box" x86 changes, bootmem/sparsemem
References: <20080426185516.GA32364@elte.hu>
	<alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
	<20080426194143.GA8366@elte.hu> <87hcdmnccu.fsf@saeurebad.de>
	<20080427234630.GC14338@elte.hu>
Date: Mon, 28 Apr 2008 02:19:14 +0200
In-Reply-To: <20080427234630.GC14338@elte.hu> (Ingo Molnar's message of "Mon,
	28 Apr 2008 01:46:30 +0200")
Message-ID: <877iein859.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar <mingo@elte.hu> writes:

> * Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> >       mm: allow reserve_bootmem() cross nodes
>> 
>> I find it sad that this goes in now.  I wrote a clean version of 
>> reserve_bootmem() [1] and it was rejected with arguments that I did 
>> not understand [2] and that were not further explained even though I 
>> asked for it [3].
>> 
>> http://lkml.org/lkml/2008/4/16/76
>> http://lkml.org/lkml/2008/4/16/234
>> http://lkml.org/lkml/2008/4/16/250
>
> oh, i had your patches applied then undid them due to this:
>
>    http://www.ussg.iu.edu/hypermail/linux/kernel/0804.2/0253.html
>
> havent seen a followup to that mail so it was 'issue pending'.

> so i very much agree that your changes are cleaner, i just wanted to 
> have one that has all the fixes included.

I had planned this to be another patch because there are more then one
boundary check I wanted to tighten.  I can merge them though if you
like.

> Would you like to post a patch against current -git or should i extract 
> the cleaner reserve_bootmem() from your previous patch?

I just moved and have only sporadic internet access and free time slots
available.  Would be nice if you could do it!

> 	Ingo

Thanks!

	Hannes
