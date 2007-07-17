Return-Path: <linux-kernel-owner+w=401wt.eu-S1764780AbXGQA7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764780AbXGQA7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763492AbXGQA6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:58:48 -0400
Received: from smtpq3.tilbu1.nb.home.nl ([213.51.146.202]:39248 "EHLO
	smtpq3.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763385AbXGQA6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:58:47 -0400
Message-ID: <469C1409.9010305@gmail.com>
Date: Tue, 17 Jul 2007 02:57:45 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Bodo Eggert <7eggert@gmx.de>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8FO1e-2jW-35@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>	 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com>	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>	 <469BF104.1040703@gmail.com>	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>	 <469BF768.6040200@gmail.com>	 <2c0942db0707161613lff9c07bpcf002b9139163a86@mail.gmail.com>	 <469BFDA7.1040204@gmail.com> <2c0942db0707161640h3c3afd7avecd7b3c61c4e7df1@mail.gmail.com>
In-Reply-To: <2c0942db0707161640h3c3afd7avecd7b3c61c4e7df1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2007 01:40 AM, Ray Lee wrote:

> On 7/16/07, Rene Herman <rene.herman@gmail.com> wrote:
>> On 07/17/2007 01:13 AM, Ray Lee wrote:
>> 
>> > Given that there's actual, y'know, reports of people who can easily
>> > crash a 4k+interrupt stacks kernel, and not an 8k one, I think the
>> > current evidence speaks for itself.
>>
>> Where?
> 
> The second message in this thread, according to my reader, from Zan
> Lynx. Another from Utz Lehmann a few minutes ago.

True enough. I'm rather wondering though why RHEL is shipping with it if 
it's a _real_ problem. Scribbling junk all over kernel memory would be the 
kind of thing I'd imagine you'd mightely piss-off enterprise customers with. 
But well, sure, that rather quickly becomes a self-referential argument I guess.

>> Removing any such option was not the objective of this thread, just 
>> lifting 4K stacks from debug and making it the default.
> 
> True, but your messages are reading as advocacy for removing the 8k
> option. I'm saying that's a bad idea. If I misunderstood your
> position, then my bad.

I personally believe that CONFIG_4KSTACKS is not better only for very few 
users but well, no, if even some users exist, then I wouldn't want to 
suggest they'd be disallowed (shared or unshared) 8K stacks.

I _would_ in fact suggest there are few enough left that rather than 4K, 8K 
should really be the option that only those few would select, but ofcourse, 
given config defaults that's mostly a matter of semantics, so who cares in 
the end.

> If they even realize that it's the cause of the problem. In the
> meantime, we're generating more bug reports to lkml. As the general
> opinion is that the ones getting received now aren't getting enough
> attention (see regression tracking threads), setting a default that is
> known to break setups in hard to debug ways seems counterproductive.

Well, no. "oldconfig" works fine, and other than that, all failure modes 
I've heard about also in this thread are MD/LVM/XFS. This is extremely 
widely tested stuff in at least Fedora and RHEL. "hard to debug" is simply 
not the case -- every one will immediately start yelling 4KSTACKS when that 
software-stack appears anywhere.

Don't try and hang this off generic development unease... ;-)

Rene.

