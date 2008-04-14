Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYDNFTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYDNFTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 01:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYDNFTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 01:19:14 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60815 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYDNFTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 01:19:13 -0400
Message-ID: <4802E93E.4090205@bull.net>
Date: Mon, 14 Apr 2008 07:18:54 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: efault@gmx.de, manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH 00/13] Re: Scalability requirements for sysv ipc
References: <20080411161702.460410000@bull.net> <1207931235.7157.0.camel@twins>
In-Reply-To: <1207931235.7157.0.camel@twins>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2008-04-11 at 18:17 +0200, Nadia.Derbey@bull.net wrote:
> 
>>Here is finally the ipc ridr-based implementation I was talking about last
>>week (see http://lkml.org/lkml/2008/4/4/208).
>>I couldn't avoid much of the code duplication, but at least made things
>>incremental.
>>
>>Does somebody now a test suite that exists for the idr API, that I could
>>run on this new api?
>>
>>Mike, can you try to run it on your victim: I had such a hard time building
>>this patch, that I couldn't re-run the test on my 8-core with this new
>>version. So the last results I have are for 2.6.25-rc3-mm1.
>>
>>Also, I think a careful review should be done to avoid introducing yet other
>>problems :-(
> 
> 
> Why duplicate the whole thing, when we converted the Radix tree to be
> RCU safe we did it in-place. Is there a reason this is not done for idr?
> 
> 
> 

I did that because I wanted to go fast and try to fix the performance 
problem we have with sysV ipc's. I didn't want to introduce (yet other) 
regressions in the code that uses idr's today and that works well ;-)
May be in the future if this rcu based api appears to be ok, we can 
replace one with the other?

Regards,
Nadia



