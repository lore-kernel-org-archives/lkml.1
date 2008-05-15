Return-Path: <linux-kernel-owner+w=401wt.eu-S1763528AbYEOSPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763528AbYEOSPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758453AbYEOSPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:15:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45614 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198AbYEOSPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:15:03 -0400
Message-ID: <482C7DA3.1090809@garzik.org>
Date: Thu, 15 May 2008 14:14:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>	<20080515142154.0595e475@core>	<36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <20080515173939.1ec968be@core>
In-Reply-To: <20080515173939.1ec968be@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> In short, I agree with Alan's IRQF_SAMPLE_DUBIOUS, and know of Linux
>> customers who also want the same.
> 
> They should be made to read the Debian ssh security report - three times
> and understand the same would apply to them if something did cause their
> network packet arrivals to be observed or non-random
> 
> Far better would be to get your CPU guys to put an RNG back into the
> systems or on the CPU die ala VIA. Given I've even seen people using VIA
> boxes as a random number feeder (streaming random numbers over SSL) there
> is clearly a demand 8)

The Treacherous Platform Module includes an RNG.

Someone (hi Jesse?) should implement support for TPM_GetRandom.

All the specs are public, and the hardware is already in users' hands.

	Jeff




