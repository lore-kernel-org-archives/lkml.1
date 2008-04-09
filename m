Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYDISUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYDISUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbYDISUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:20:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46837 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbYDISUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:20:24 -0400
Date: Wed, 9 Apr 2008 20:24:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jason Baron <jbaron@redhat.com>,
       Adrian Bunk <bunk@stusta.de>, Christoph Hellwig <hch@infradead.org>,
       akpm@osdl.org
Subject: Re: [patch 09/17] Add all cpus option to stop machine run
Message-ID: <20080409182454.GF30885@one.firstfloor.org>
References: <20080409150829.855195878@polymtl.ca> <20080409152049.513274847@polymtl.ca> <20080409181010.GA4924@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409181010.GA4924@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 10:10:10PM +0400, Alexey Dobriyan wrote:
> I continue to think that all this so-called "immediate" infrastructure
> is an absolute overkill and declared D-cache line savings will _never_
> matter 

You are quite wrong on that.

> and will never be measured on real life workloads. Right now you
> claim 1 (one) cacheline saving in schedule() which can be trivially

That is just an example. Once the infrastructure is in a lot more
flags would move it into it. I think eventually most sysctls
should be immediate values for once.

> Also, my gut feeling of a guy who is also on receiveing end of bugreports
> at SWsoft that line with .text games was crossed by SMP alternatives and

You already lost -- Linux regularly rewrites itself. Ok not quite yet
but self modifying code is already wide spread and happens commonly
(e.g. with alternatives and some other cases) 

> 
> And bugs when CPU executed bullshit and silently rebooted.

So far nobody has seen that and the probably of it actually happening
is rather remote too.


> And so on.
> 
> 	Alexey, more and more liking OpenBSD
> 		where such games won't even
> 	        hit mailing lists

Maybe that is why Linux scales to large systems and OpenBSD 
doesn't ...

-Andi

