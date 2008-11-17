Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbYKQWjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbYKQWjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYKQWjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:39:33 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:38147 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYKQWjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:39:32 -0500
Message-ID: <4921F28F.4020300@cosmosbay.com>
Date: Mon, 17 Nov 2008 23:39:11 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Bug #11308] tbench regression on each kernel release from	2.6.22
 -&gt; 2.6.28
References: <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117220828.GB6398@elte.hu> <4921ED16.9050307@cosmosbay.com> <20081117222640.GA17880@elte.hu>
In-Reply-To: <20081117222640.GA17880@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 17 Nov 2008 23:39:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> Ingo Molnar a écrit :

>>> it's this division:
>>>
>>>         if (doing_tso) {
>>>         [...]
>>> 			xmit_size_goal -= (xmit_size_goal % mss_now);
>>>
>>> Has no-one hit this before? Perhaps this is why switching loopback  
>>> networking to TSO had a performance impact for others?
>> Yes, I mentioned it later. [...]
> 
> i see - i just caught up with some of my inbox from today.
> 
>> [...] But apparently you dont read my mails, so I will just stop 
>> now.
> 
> Sorry, i spent my time looking at the profile output.
> 

No problem Ingo, I am very glad you take so much time to profil kernel ;)

I had too many problems with profilers on my dev machine lately :(


