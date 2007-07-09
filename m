Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbXGICr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbXGICr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbXGICrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:47:20 -0400
Received: from gw.goop.org ([64.81.55.164]:39356 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757781AbXGICrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:47:19 -0400
Message-ID: <4691A196.7080305@goop.org>
Date: Sun, 08 Jul 2007 19:46:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
References: <20070617214231.GA3588@stusta.de> <46760D87.2000502@goop.org> <20070708224444.GU3492@stusta.de>
In-Reply-To: <20070708224444.GU3492@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>>> Reverting is safe since it simply re-establishes the 2.6.21 status quo.
>>>       
>> Well, not really.  It breaks any non-GPL module when CONFIG_PARAVIRT is
>> enabled, even though the same module would work fine otherwise.  That's
>> a pretty large regression.
>> ...
>>     
>
> The 2.6.21 status quo can by definition not be a regression compared
> to 2.6.21.
>   

2.6.21's behaviour was a bug.  CONFIG_PARAVIRT is not supposed to cause 
any behavioural changes.

    J
