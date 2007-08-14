Return-Path: <linux-kernel-owner+w=401wt.eu-S934779AbXHNUjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934779AbXHNUjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759318AbXHNUja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:39:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:32410 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594AbXHNUj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:39:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,261,1183359600"; 
   d="scan'208";a="117522276"
Message-ID: <46C212E2.3020401@intel.com>
Date: Tue, 14 Aug 2007 13:38:58 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Rick Jones <rick.jones2@hp.com>
CC: David Miller <davem@davemloft.net>, greearb@candelatech.com,
       jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add ETHTOOL_[GS]FLAGS sub-ioctls
References: <46BCD47C.9060408@candelatech.com>	<20070810.151039.31642625.davem@davemloft.net>	<46BCE942.1030107@candelatech.com> <20070810.154601.98709831.davem@davemloft.net> <46BCF1AF.3080000@hp.com>
In-Reply-To: <46BCF1AF.3080000@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Aug 2007 20:39:27.0687 (UTC) FILETIME=[353A3D70:01C7DEB3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rick Jones wrote:
> David Miller wrote:
>> From: Ben Greear <greearb@candelatech.com>
>> Date: Fri, 10 Aug 2007 15:40:02 -0700
>>
>>
>>> For GSO on output, is there a generic fallback for any driver that
>>> does not specifically implement GSO?
>>
>> Absolutely, in fact that's mainly what it's there for.
>>
>> I don't think there is any issue.  The knob is there via
>> ethtool for people who really want to disable it.
> 
> Just to be paranoid (who me?) we are then at a point where what happened 
> a couple months ago with forwarding between 10G and IPoIB won't happen 
> again - where things failed because a 10G NIC had LRO enabled by default?

we still have the NETIF_F_LRO flag which Jeff will keep around. Perhaps the 
IPoIB code can force this to _off_ when setting it up? (or at least warn about it).

Auke
