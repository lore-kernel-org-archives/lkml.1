Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab0BTH53 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 02:57:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab0BTH51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 02:57:27 -0500
Message-ID: <4B7F96AE.1010102@redhat.com>
Date: Sat, 20 Feb 2010 16:00:46 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Octavian Purdila <opurdila@ixiacom.com>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [net-next PATCH v4 3/3] net: reserve ports for applications using
 fixed port numbers
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com>	 <1266271241-6293-4-git-send-email-opurdila@ixiacom.com>	 <4B7A6740.1000701@redhat.com> <201002161306.29708.opurdila@ixiacom.com>	 <4B7A9852.5020105@redhat.com> <1266326425.3045.53.camel@edumazet-laptop>	 <4B7C159A.3060603@redhat.com> <1266424768.3075.61.camel@edumazet-laptop>
In-Reply-To: <1266424768.3075.61.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Le jeudi 18 février 2010 à 00:13 +0800, Cong Wang a écrit :
> 
>> I don't think so, if you want to avoid race condition, you just need to
>> write the reserved ports before any networking application starts, IOW,
>> as early as possible during boot.
>>
> 
> Sure, but I was thinking retrieving the list of reserved port by a
> database query, using network :)
> 
> Anyway, I just feel your argument is not applicable.
> 
> Our kernel is capable of doing an intersection for us, we dont need
> to forbid user to mark a port as 'reserved' if this port is already
> blacklisted by another mechanism (for example, if this port is already
> in use)
> 

Oh, I see your points.

But this still could make people confused, like me. I think we'd better
document this.

Thanks.
