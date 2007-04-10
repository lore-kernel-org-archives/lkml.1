Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbXDJLEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbXDJLEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbXDJLEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:04:37 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3471 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753460AbXDJLEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:04:36 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: peter.p.waskiewicz.jr@intel.com (Waskiewicz Jr, Peter P)
Subject: Re: [PATCH 2/2] NET: Multiqueue network device support implementation.
Cc: jengelh@linux01.gwdg.de, davem@davemloft.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com, cramerj@intel.com,
       auke-jan.h.kok@intel.com, christopher.leech@intel.com
Organization: Core
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC329029E400C@orsmsx414.amr.corp.intel.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HbE8w-0000LY-00@gondolin.me.apana.org.au>
Date: Tue, 10 Apr 2007 21:04:10 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Waskiewicz Jr, Peter P <peter.p.waskiewicz.jr@intel.com> wrote:
>
>> >@@ -3356,6 +3370,7 @@ void free_netdev(struct net_device *dev)
>> >     /* will free via device release */
>> >     put_device(&dev->dev);
>> > #else
>> >+    kfree((char *)dev->egress_subqueue);
>> >     kfree((char *)dev - dev->padded);
>> > #endif
>> > }
>> 
>> Ahem. Explain that cast.
> 
>        This can be removed if needed; however, I'm just copying what
> the other kfree()'s are doing in this function.  Any instance of a
> typecast that I introduced in these patches are just following what
> others have done in that section of the code.  So the cast is just for
> consistency in this particular area.  If you'd like me to remove it, I
> can do that.

The other cast is there for the subtraction, not the kfree...

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
