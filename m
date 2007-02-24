Return-Path: <linux-kernel-owner+w=401wt.eu-S933517AbXBXQko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbXBXQko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 11:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbXBXQko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 11:40:44 -0500
Received: from stinky.trash.net ([213.144.137.162]:55536 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbXBXQkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 11:40:43 -0500
Message-ID: <45E06A86.2060408@trash.net>
Date: Sat, 24 Feb 2007 17:40:38 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 18/29] netfilter: notify about NF_QUEUE vs	emergency	skbs
References: <20070221144304.512721000@taijtu.programming.kicks-ass.net>	 <20070221144843.299254000@taijtu.programming.kicks-ass.net>	 <45E05954.8050204@trash.net> <1172332010.28579.6.camel@lappy>	 <45E064FF.8010000@trash.net> <1172333937.6374.47.camel@twins>
In-Reply-To: <1172333937.6374.47.camel@twins>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sat, 2007-02-24 at 17:17 +0100, Patrick McHardy wrote:
> 
> 
>>I don't really see why
>>queueing is special though, dropping the packets in the ruleset
>>will break things just as well, as will routing them to a blackhole.
>>I guess the user just needs to be smart enough not to do this.
> 
> 
> Its user-space and no emergency packet may rely on user-space because it
> most likely is needed to maintain user-space.

I believe I might have misunderstood the intention of this patch.

Assuming the user is smart enough not to queue packets destined
to a SOCK_VMIO socket, are you worried about unrelated packets
allocated from the emergency reserve not getting freed fast
enough because they're sitting in a queue? In that case simply
dropping the packets would be fine I guess.

