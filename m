Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbXHJEPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbXHJEPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 00:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbXHJEPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 00:15:39 -0400
Received: from mail.tmr.com ([64.65.253.246]:60785 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbXHJEPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 00:15:38 -0400
Message-ID: <46BBE6D9.1080904@tmr.com>
Date: Fri, 10 Aug 2007 00:17:29 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: richard kennedy <richard@rsk.demon.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070803123712.987126000@chello.nl>	<1186575947.3106.23.camel@castor.rsk.org> <p734pjarv20.fsf@bingen.suse.de>
In-Reply-To: <p734pjarv20.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> richard kennedy <richard@rsk.demon.co.uk> writes:
>> This is on a standard desktop machine so there are lots of other
>> processes running on it, and although there is a degree of variability
>> in the numbers,they are very repeatable and your patch always out
>> performs the stock mm2.
>> looks good to me
> 
> iirc the goal of this is less to get better performance, but to avoid long user visible
> latencies.  Of course if it's faster it's great too, but that's only secondary.
> 
What a trade-off, if you want to get rid of long latency you have to 
live with better throughput. I can live with that. ;-)

Your point well taken, not the intent of the patch, but it may indicate 
where a performance bottleneck happens as well.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
