Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZBGGDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZBGGDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 01:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZBGGDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 01:03:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:27214 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbZBGGDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 01:03:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,395,1231142400"; 
   d="scan'208";a="108191523"
Message-ID: <498D241F.4080005@intel.com>
Date: Fri, 06 Feb 2009 23:03:11 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: "anemo@mba.ocn.ne.jp" <anemo@mba.ocn.ne.jp>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net_dma: call dmaengine_get only if NET_DMA enabled
References: <20090206.140912.40800913.davem@davemloft.net>	<e9c3a7c20902061452r40a97fa2p1fccfa78e3905458@mail.gmail.com>	<20090206.192910.42610645.davem@davemloft.net> <20090206.215533.166740686.davem@davemloft.net>
In-Reply-To: <20090206.215533.166740686.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Fri, 06 Feb 2009 19:29:10 -0800 (PST)
> 
>> From: Dan Williams <dan.j.williams@intel.com>
>> Date: Fri, 6 Feb 2009 15:52:35 -0700
>>
>>> Yes, it has been on the todo list for a while, but I eventually want
>>> the net case to look more like the raid case.  I.e. have one code path
>>> that picks async versus sync at runtime, with the option to compile
>>> out async support with header file ifdefs only.
>> And how does any of that get us any closer to a fix right now
>> for this problem that doesn't require an ifdef?
>>
>> Someone please work on this.
> 
> I guess that'd end up being me....

Not necessarily, you did snap me back into reality with that comment.

> 
> How about something like this?

Looks good.

Thanks,
Dan

