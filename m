Return-Path: <linux-kernel-owner+w=401wt.eu-S1763460AbYEOTKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763460AbYEOTKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbYEOTKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:10:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52372 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbYEOTKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:10:21 -0400
Message-ID: <482C8A99.80702@garzik.org>
Date: Thu, 15 May 2008 15:10:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>	<20080515142154.0595e475@core>	<36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <20080515173939.1ec968be@core> <482C7DA3.1090809@garzik.org> <482C854C.7070405@intel.com>
In-Reply-To: <482C854C.7070405@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Jeff Garzik wrote:
>> Alan Cox wrote:
>>>> In short, I agree with Alan's IRQF_SAMPLE_DUBIOUS, and know of Linux
>>>> customers who also want the same.
>>> They should be made to read the Debian ssh security report - three times
>>> and understand the same would apply to them if something did cause their
>>> network packet arrivals to be observed or non-random
>>>
>>> Far better would be to get your CPU guys to put an RNG back into the
>>> systems or on the CPU die ala VIA. Given I've even seen people using VIA
>>> boxes as a random number feeder (streaming random numbers over SSL) there
>>> is clearly a demand 8)
>> The Treacherous Platform Module includes an RNG.
>>
>> Someone (hi Jesse?) should implement support for TPM_GetRandom.
> 
> Sounds like something he should neither use in the e1000 driver nor implement :)
> 
> This would be an interesting thing to the generic rng support in linux though

That's what I meant.  Support should be implemented in the appropriate 
place in order to solve the problem Jesse's complaining about.  That 
appropriate place being drivers/char/hw_random/

	Jeff




