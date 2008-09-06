Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYIFQJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYIFQJf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 12:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYIFQJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 12:09:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37935 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYIFQJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 12:09:25 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <6693458.1220717142061.kamezawa.hiroyu@jp.fujitsu.com>
Date: Sun, 7 Sep 2008 01:05:42 +0900 (JST)
To: kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: Re: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
Cc: Ingo Molnar <mingo@elte.hu>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Gary Hade <garyhade@us.ibm.com>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
In-Reply-To: <9031244.1220716855172.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <9031244.1220716855172.kamezawa.hiroyu@jp.fujitsu.com>
 <20080906143318.GA23621@elte.hu>
 <20080905215452.GF11692@us.ibm.com> <20080906000154.GC18288@one.firstfloor.org> <20080906153855.7260.E1E9C6FF@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>>Having said that, i have my doubts about its generic utility (the power 
>>saving aspects are likely not realizable - nobody really wants DIMMs to 
>>just sit there unused and the cost of dynamic migration is just 
>>horrendous) - but as long as it's opt-in there's no reason to limit the 
>>availability of an in-kernel feature artificially.
>
>Nobody ? maybe just a trade-off problem in user side. 
>Even without DIMM hotplug or DIMM's power save mode, making a DIMM idle
>is of no use ? I think memory consumes much power when it used.
>Memory Hotplug and ZONE_MOVABLE can make some memory idle.
>(I'm sorry if my thinking is wrong.)
>
But I have to point out HDD access consumes far power than memory.
That's trade-off problem depends on usage, anyway.

Thanks,
-Kame
