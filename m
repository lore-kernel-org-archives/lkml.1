Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbZIQRv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbZIQRv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZIQRvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:51:55 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:41262 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217AbZIQRvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e2dzs40GN1jtyZ8MxFz1SyqA682kZktZ/PRMC3wqdspdE7qvNf2iEkcSVeGLL3zOkk
         9O1mGlVIzHJVUDCR+yoktGRBjDDDzEZKU2idWxRvEKvY5QymyYJ6ocRXk24eB1KlVGIQ
         w6df0+yGWWBqvuL2iFVlJGJKnYlPXjIWWA/Oo=
Date: Thu, 17 Sep 2009 21:51:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [crash] kernel BUG at net/core/pktgen.c:3503!
Message-ID: <20090917175155.GC8817@lenovo>
References: <20090911.202543.52533792.davem@davemloft.net> <20090915183647.GA11628@elte.hu> <20090915185112.GA17587@lenovo> <20090917.102923.174779685.davem@davemloft.net> <20090917174448.GA9548@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917174448.GA9548@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Thu, Sep 17, 2009 at 07:44:48PM +0200]
...
| 
| > 
| > Ingo, does Cyrill's patch help?
| 
| For now i've turned pktgen off in my tests. Will check it again once 
| things have calmed down somewhat.
| 
| Also, i just tried to reproduce the pktgen crash with latest -git and 
| the config i sent - no luck, so i cannot test Cyrill's patch either.
| 
| Btw., we are seeing some other preempt count and task related 
| weirdnesses as well in other code, maybe it's related. No good pattern 
| yet to act upon.
| 
| Anyway - please disregard this bugreport until i've investigated it 
| closer.
| 
| 	Ingo
| 

I'm unable to reproduce this issue too. I was trying
many ways (under kvm) -- no bug triggered. Though on
a system for which I had done this patch in first place
the bug was been hitting all the time (but it contains
custom vcpu management code, which is not our case here).

	-- Cyrill
