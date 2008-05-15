Return-Path: <linux-kernel-owner+w=401wt.eu-S1764513AbYEOSvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764513AbYEOSvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763450AbYEOSue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:50:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:11635 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763383AbYEOSud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:50:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,493,1204531200"; 
   d="scan'208";a="281892339"
Message-ID: <482C854C.7070405@intel.com>
Date: Thu, 15 May 2008 11:47:40 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080417)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>	<20080515142154.0595e475@core>	<36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <20080515173939.1ec968be@core> <482C7DA3.1090809@garzik.org>
In-Reply-To: <482C7DA3.1090809@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Alan Cox wrote:
>>> In short, I agree with Alan's IRQF_SAMPLE_DUBIOUS, and know of Linux
>>> customers who also want the same.
>>
>> They should be made to read the Debian ssh security report - three times
>> and understand the same would apply to them if something did cause their
>> network packet arrivals to be observed or non-random
>>
>> Far better would be to get your CPU guys to put an RNG back into the
>> systems or on the CPU die ala VIA. Given I've even seen people using VIA
>> boxes as a random number feeder (streaming random numbers over SSL) there
>> is clearly a demand 8)
> 
> The Treacherous Platform Module includes an RNG.
> 
> Someone (hi Jesse?) should implement support for TPM_GetRandom.

Sounds like something he should neither use in the e1000 driver nor implement :)

This would be an interesting thing to the generic rng support in linux though

Auke
