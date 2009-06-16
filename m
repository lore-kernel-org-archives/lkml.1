Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZFPTia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZFPTia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZFPTiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:38:19 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:37954 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbZFPTiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:38:18 -0400
Message-ID: <4A37F495.9030101@gmail.com>
Date: Tue, 16 Jun 2009 21:37:57 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, mingo@elte.hu, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
References: <4A37A058.1030701@gmail.com>	<4A37AA0C.40507@gmail.com>	<alpine.LFD.2.01.0906161155400.3282@localhost.localdomain> <20090616.120829.182011393.davem@davemloft.net>
In-Reply-To: <20090616.120829.182011393.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 16 Jun 2009 21:38:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 16 Jun 2009 11:59:34 -0700 (PDT)
> 
>> At the very least, add a helper function for "do I actually have 
>> outstanding allocations" or something like that. IOW, do a 
>>
>> 	/*
>> 	 * Comment here about that magical "1"
>> 	 */
>> 	static inline int sk_has_allocations(struct sock *sk)
>> 	{
>> 		return atomic_read(&sk->sk_wmem_alloc) > 1 ||
>> 			atomic_read(&sk->sk_rmem_alloc);
>> 	}
>>
>> and then make the various network protocols use that, rather than 
>> open-coding some random internal implementation magic.
> 
> I agree, this should be handled with a helper function
> abstraction rather than putting "1" checks all over the place.

Fair enough, I'll submit an updated patch in following hour.

Thank you
