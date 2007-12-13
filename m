Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbXLMQsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbXLMQsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763822AbXLMQqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:46:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:51857 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760453AbXLMQqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:46:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,162,1196668800"; 
   d="scan'208";a="237097461"
Message-ID: <476161AB.2080306@intel.com>
Date: Thu, 13 Dec 2007 08:45:31 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: gallatin@myri.com, joonwpark81@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, jesse.brandeburg@intel.com
Subject: Re: [RFC] net: napi fix
References: <47602B77.2090202@intel.com>	<b25c3fa70712122341q3ba282cdqda3fa56901b14484@mail.gmail.com>	<47613E22.6060705@myri.com> <20071213.061938.86541759.davem@davemloft.net>
In-Reply-To: <20071213.061938.86541759.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Dec 2007 16:46:10.0782 (UTC) FILETIME=[AA67C7E0:01C83DA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Andrew Gallatin <gallatin@myri.com>
> Date: Thu, 13 Dec 2007 09:13:54 -0500
> 
>> If the netif_running() check is indeed required to make a device break
>> out of napi polling and respond to an ifconfig down, then I think the
>> netif_running() check should be moved up into net_rx_action() to avoid
>> potential for driver complexity and bugs like the ones you found.
> 
> That, or something like it, definitely sounds reasonable and much
> better than putting the check into every driver :-)

hear hear!

Auke
