Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZINDbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZINDbj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 23:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZINDbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 23:31:38 -0400
Received: from mga06.intel.com ([134.134.136.21]:21836 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753603AbZINDbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 23:31:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,381,1249282800"; 
   d="scan'208";a="448189138"
Subject: Re: PATCH] cpuidle: A new variant of the menu governor to boost IO
	performance
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: John Stoffel <john@stoffel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       lenb@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       peterz@infradead.org, torvalds@linux-foundation.org,
       jens.axboe@oracle.com
In-Reply-To: <19114.41505.479086.782442@stoffel.org>
References: <20090911174019.1ed02737@infradead.org>
	 <19114.41505.479086.782442@stoffel.org>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 11:30:10 +0800
Message-Id: <1252899010.2606.25.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 15:16 -0400, John Stoffel wrote:
> >>>>> "Arjan" == Arjan van de Ven <arjan@infradead.org> writes:
> 
> Arjan> From: Arjan van de Ven <arjan@linux.intel.com>
> Arjan> Subject: [PATCH] cpuidle: A new variant of the menu governor
> 
> Arjan> This patch adds a new idle governor which balances power savings,
> Arjan> energy efficiency and performance impact.
> 
> Arjan> The reason for a reworked governor is that there have been
> Arjan> serious performance issues reported with the existing code
> Arjan> on Nehalem server systems.
> 
> Arjan> To show this I'm sure Andrew wants to see benchmark results:
> Arjan> (benchmark is "fio", "no cstates" is using "idle=poll")
> 
> Arjan> 		no cstates	current linux	new algorithm
> Arjan> 1 disk		107 Mb/s	85 Mb/s		105 Mb/s
> Arjan> 2 disks		215 Mb/s	123 Mb/s	209 Mb/s
> Arjan> 12 disks	590 Mb/s	320 Mb/s	585 Mb/s
> 
> Don't you need another row or three where you show a) how much time
> each test took,
We start fio and always ask it running for 15 minutes.

>  and b) how much (or average) power used for the
> duration of the test?  
The power consumption with the patch almost is equal to the one
without the patch. But the fio result is far better with the patch.

> 
> I'm just curious if the new algorithm (or even the current one!) saves
> any appreciable power over the 'no cstates' case.  It's not clear what
> the savings are.  
> 
> Also, latency in terms of switching to higher power and then back down
> would be nice to see.
> 
> Cheers,
> John

