Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbXKMKVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbXKMKVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXKMKVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:21:42 -0500
Received: from stinky.trash.net ([213.144.137.162]:41083 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbXKMKVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:21:41 -0500
Message-ID: <47397AB3.90705@trash.net>
Date: Tue, 13 Nov 2007 11:21:39 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Joonwoo Park <joonwpark81@gmail.com>
CC: David Miller <davem@davemloft.net>, w@1wt.eu, cfriesen@nortel.com,
       auke-jan.h.kok@intel.com, netdev@vger.kernel.org,
       djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous
 mode
References: <20071112231516.GA15227@1wt.eu>	 <20071112.151923.77768525.davem@davemloft.net>	 <20071112233257.GA15524@1wt.eu>	 <20071112.154046.117031917.davem@davemloft.net> <b25c3fa70711121721o32bcab0fldf64ff0434a44a3c@mail.gmail.com>
In-Reply-To: <b25c3fa70711121721o32bcab0fldf64ff0434a44a3c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joonwoo Park wrote:
> 2007/11/13, David Miller <davem@davemloft.net>:
>   
>> From: Willy Tarreau <w@1wt.eu>
>> Date: Tue, 13 Nov 2007 00:32:57 +0100
>>
>>     
>>> At least, being able to disable the feature at module load time
>>> would be acceptable. Many people who often need to sniff on decent
>>> machines would always keep it disabled.
>>>       
>> I'm willing to accept the feature, in whatever form, as long
>> as the performance issue is dealt with properly.
>>     
>
> I agree with disabling the hw acceleration feature by manually would
> be a non-negative solution.
> IMO implementation in the ethtool seems better than module param.
> As like Auke mentioned.
> If you guys confirm it, I'll try it.
>   

I still think promiscous mode should disable all filters (which would
also provide a consistent view between accerlated and non-accerlated
devices), but an ethtool option is better than nothing :)

