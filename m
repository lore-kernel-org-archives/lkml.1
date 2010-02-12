Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab0BLNQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 08:16:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:54927 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab0BLNQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 08:16:45 -0500
Message-ID: <4B755656.7000904@kernel.org>
Date: Fri, 12 Feb 2010 22:23:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: upcoming percpu changes
References: <20100205161648.086375b9.sfr@canb.auug.org.au>	<4B750F80.2030902@kernel.org> <20100212221058.37b7c6e6.sfr@canb.auug.org.au>
In-Reply-To: <20100212221058.37b7c6e6.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Feb 2010 13:16:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/12/2010 08:10 PM, Stephen Rothwell wrote:
> A good start would be commit d3f5fa4075414c7754126fbdc7c8fbd3906db7c8
> ("percpu: add __percpu sparse annotations to net").  You would need to
> rebase it on top of net-next and note that "struct macvlan_dev" has been
> moved to include/linux/if_macvlan.h.  Then just send it to DaveM.
> 
> You could also send commit e20b68160144bcacbde008b9cf7df4e1544b2507
> ("percpu: add __percpu sparse annotations to net drivers") along with it.
> 
> Commit 949c49c93a02b62278a63457d0d3192d66e55105 ("percpu: add __percpu
> sparse annotations to x86") can just go to the x86 guys and commit
> 0b6dd45041220083a3692edae5253c35d19bcb2b ("percpu: add __percpu sparse
> annotations to hw_breakpoint") to Frederic Weisbecker.
> 
> Commit eeb721be6bc03fe37755e69ab5c3ba2fe9897fd9 ("percpu: add __percpu
> sparse annotations to trace") needs rebasing onto the tip perf/core
> branch and then could be sent to Steve and co.
> 
> That takes care of most of it and the rest, as you say, we can sort out
> if it becomes a problem.

The changes being basically trivial, it doesn't seem to bring much
benefit but yeah sure I can send those chunks to the maintainers.

Thanks.

-- 
tejun
