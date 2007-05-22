Return-Path: <linux-kernel-owner+w=401wt.eu-S1765072AbXEVJUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765072AbXEVJUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbXEVJU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:20:26 -0400
Received: from stinky.trash.net ([213.144.137.162]:43408 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbXEVJUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:20:24 -0400
Message-ID: <4652B53B.8080500@trash.net>
Date: Tue, 22 May 2007 11:17:47 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Anant Nitya <kernel@prachanda.info>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: bad networking related lag in v2.6.22-rc2
References: <20070517174533.GA538@elte.hu> <465208D2.6070409@trash.net> <46520F77.5000408@trash.net> <200705221147.56571.kernel@prachanda.hub>
In-Reply-To: <200705221147.56571.kernel@prachanda.hub>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anant Nitya wrote:
>>Patrick McHardy wrote:
>>
>>I think I already found the bug, please try if this patch helps.
> 
> 
> Sorry, but this patch is not helping here. I recompiled the kernel with this 
> patch but same load pattern still make system to crawl.
> 
> Here is the link for script I use to shape traffic.
> 
> http://cybertek.info/taitai/adslbwopt.sh


Thanks. Please also send the output of "tc -s -d qdisc show dev
ppp0" and "tc -d -s class show dev ppp0" at the time the problem
occurs.

