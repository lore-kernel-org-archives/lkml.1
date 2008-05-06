Return-Path: <linux-kernel-owner+w=401wt.eu-S933944AbYEFXKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944AbYEFXKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYEFXKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:10:37 -0400
Received: from mga06.intel.com ([134.134.136.21]:23854 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753951AbYEFXKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:10:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,445,1204531200"; 
   d="scan'208";a="380718969"
Message-ID: <4820E564.8030705@linux.intel.com>
Date: Tue, 06 May 2008 16:10:28 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: linux-next: WARNING: at kernel/panic.c:375 __stack_chk_test+0x50/0x54()
References: <20080501043313.02205bbd@linux.intel.com>	<481CF3B1.2020307@gmail.com>	<4820B64D.4000805@linux.intel.com> <20080506.133416.241365936.davem@davemloft.net> <4820E529.2030801@gmail.com>
In-Reply-To: <4820E529.2030801@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:
> David Miller wrote:
>> From: Arjan van de Ven <arjan@linux.intel.com>
>> Date: Tue, 06 May 2008 12:49:33 -0700
>>
>>> this is weird; something is adding ANOTHER -fstack-protector to the 
>>> (effective) gcc
>>> flags.. which might be overriding the -fstack-protector-all setting.
>>>
>>> I wonder if this is a distro special ;(
>>
>> Ubuntu adds -fstack-protector to the GCC command line.
>>
>> But I've been able to override it trivially when, for example, doing
>> GCC builds, by simply adding -fno-stack-protector.
> 
> I assume adding -fno-stack-protector would not really be an option in 
> this case (since if I understand correctly it would be appended to the 
> end of the flags which would turn the option off).

yeah that's counter productive ;)

> 
> I guess I'll be figuring out how to build my own gcc...

well hold on a second ;)

I'd like to do a few more experiments, but if this is really an ubuntu special thing
I'd like to at least get the ubuntu gcc folks involved.
