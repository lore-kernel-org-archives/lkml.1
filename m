Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYI3WDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYI3WDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbYI3WDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:03:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45338 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYI3WDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:03:14 -0400
Message-ID: <48E2A20F.3070604@zytor.com>
Date: Tue, 30 Sep 2008 15:02:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Typo bug [Re: Linux 2.6.27-rc8]
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>	 <20080930094346.307ef1e5@werewolf.home>	 <20080930075553.GB20241@elte.hu> <48E27425.7010705@zytor.com>	 <86802c440809301230s7dd33e69m83dab51f915580b1@mail.gmail.com>	 <48E28528.5070605@zytor.com>	 <86802c440809301435r79fb2553p65130b6451e83fa4@mail.gmail.com>	 <48E29BFE.4040309@zytor.com> <86802c440809301442l4d80ea8fqaa20db772cf14df5@mail.gmail.com>
In-Reply-To: <86802c440809301442l4d80ea8fqaa20db772cf14df5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Tue, Sep 30, 2008 at 2:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>> Dashes seem to be used more than underscores, so it probably should be
>> "mtrr-cleanup" and "nomtrr-cleanup" if you want a separator.
>>
> i need to document the mtrr_cleanup_debug too...change it to
> mtrrcleanup_debug ? just like initcall_debug?
> 

I would prefer "mtrr-cleanup-debug" if the main one is "mtrr-cleanup"; 
mixing dashes and underscores is a bit sick.  Unfortunately we have had 
very few attempts at consistency with command line options... some in 
the early days were even StudlyCaps (yuck...)

	-hpa
