Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbXKMRhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbXKMRhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbXKMRhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:37:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:55499 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbXKMRhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:37:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,411,1188802800"; 
   d="scan'208";a="381485533"
Message-ID: <4739DF29.6010901@intel.com>
Date: Tue, 13 Nov 2007 09:30:17 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>, joonwpark81@gmail.com, w@1wt.eu,
       cfriesen@nortel.com, netdev@vger.kernel.org,
       djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous
 mode
References: <E1Irtdz-0000DX-00@gondolin.me.apana.org.au> <20071113.033611.73195922.davem@davemloft.net> <20071113120328.GB1086@gondor.apana.org.au> <20071113.040624.43544149.davem@davemloft.net> <20071113121647.GA1330@gondor.apana.org.au> <4739961E.90708@trash.net> <4739D3A5.4020503@intel.com> <4739DE29.2030507@trash.net>
In-Reply-To: <4739DE29.2030507@trash.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Nov 2007 17:30:46.0824 (UTC) FILETIME=[ED0EE280:01C8261A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Kok, Auke wrote:
>> Patrick McHardy wrote:
>>
>>> I already posted a patch for this, not sure what happened to it.
>>> Auke, any news on merging the secondary unicast address support?
>>
>> I dropped the ball on that one. Care to resend it and send me one for
>> e1000e as well?
> 
> Patch for e1000 attached.
> 
> Does e1000e also work with PCI cards if I add the proper IDs?
> Otherwise I could only send an untested patch.
> 

no, e1000e will only work with pci-e adapters. The code however is largely the
same, so if you can dish me out (off-list) some test cases I can have our labs do
the testing and add this to our test repertoire.

Cheers,

Auke
