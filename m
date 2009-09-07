Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbZIGNlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbZIGNlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 09:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZIGNlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 09:41:50 -0400
Received: from 51.205.94.193.static.smilehouse.com ([193.94.205.51]:41740 "EHLO
	nysv.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbZIGNlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 09:41:50 -0400
Date: Mon, 7 Sep 2009 16:41:51 +0300
From: Markus Tornqvist <mjt@nysv.org>
To: Ingo Molnar <mingo@elte.hu>, mjt@nysv.org
Cc: Frans Pop <elendil@planet.nl>, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de
Subject: Re: [quad core results] BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907131905.GP28624@nysv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907121613.GA32097@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Cc me as I'm not a subscriber.

(LKML bounced this message once already for 8-bit headers, I'm retrying
now - sorry if someone gets it twice)

On Mon, Sep 07, 2009 at 02:16:13PM +0200, Ingo Molnar wrote:
>
>Con posted single-socket quad comparisons/graphs so to make it 100% 
>apples to apples i re-tested with a single-socket (non-NUMA) quad as 
>well, and have uploaded the new graphs/results to:
>
>  kernel build performance on quad:
>     http://redhat.com/~mingo/misc/bfs-vs-tip-kbuild-quad.jpg
[...]
>
>It shows similar curves and behavior to the 8-core results i posted 
>- BFS is slower than mainline in virtually every measurement. The 
>ratios are different for different parts of the graphs - but the 
>trend is similar.

Dude, not cool.

1. Quad HT is not the same as a 4-core desktop, you're doing it with 8 cores
2. You just proved BFS is better on the job_count == core_count case, as BFS
   says it is, if you look at the graph
3. You're comparing an old version of BFS against an unreleased dev kernel

Also, you said on http://article.gmane.org/gmane.linux.kernel/886319
"I also tried to configure the kernel in a BFS friendly way, i used 
HZ=1000 as recommended, turned off all debug options, etc. The 
kernel config i used can be found here:
http://redhat.com/~mingo/misc/config
"

Quickly looking at the conf you have
CONFIG_HZ_250=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set

CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y

And other DEBUG.

-- 
mjt

