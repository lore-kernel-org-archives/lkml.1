Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZJCKvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZJCKvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 06:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZJCKvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 06:51:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:56142 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbZJCKvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 06:51:47 -0400
Message-ID: <4AC72CEE.4010705@kernel.org>
Date: Sat, 03 Oct 2009 19:52:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: cl@linux-foundation.org
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, mingo@elte.hu,
       rusty@rustcorp.com.au, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 11/20] RCU: Use this_cpu operations
References: <20091001212521.123389189@gentwo.org> <20091001212559.690311062@gentwo.org>
In-Reply-To: <20091001212559.690311062@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 03 Oct 2009 10:51:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cl@linux-foundation.org wrote:
> RCU does not do dynamic allocations but it increments per cpu variables
> a lot. These instructions results in a move to a register and then back
> to memory. This patch will make it use the inc/dec instructions on x86
> that do not need a register.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Patch titles slightly cleaned up and 0001-0011 are committed and
published to percpu#for-next.

Thanks.

-- 
tejun
