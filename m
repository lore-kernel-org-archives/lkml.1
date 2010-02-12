Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0BLIO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 03:14:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:36223 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab0BLIOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 03:14:25 -0500
Message-ID: <4B750F80.2030902@kernel.org>
Date: Fri, 12 Feb 2010 17:21:20 +0900
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
References: <20100205161648.086375b9.sfr@canb.auug.org.au>
In-Reply-To: <20100205161648.086375b9.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Feb 2010 08:13:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen.

On 02/05/2010 02:16 PM, Stephen Rothwell wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 5 Feb 2010 16:09:11 +1100
> Subject: [PATCH] percpu: add __percpu for sparse
> 
> This is to make the annotation of percpu variables during the next merge
> window less painfull.
> 
> Extracted from a patch by Rusty Russell.

I started doing this and it's a bit ridiculous.  If I split the
patches into separate trees with maintainers, I end up with a lot of
one or several liners and all that those patches do is adding __percpu
to a variable or field declaration which doesn't affect normal builds
at all.  The only conflicts I had against the current mainline is the
ones which got changed in the percpu tree by Christoph's patches.

Given the wide number of trees this will end up on and given the
triviality of each change, I think it would better to keep these in
the percpu tree.  It'll make things harder track without adding much
benefit.  If non-trivial confict ever happens, please feel free to
drop it from linux-next and let me know.

Thanks.

-- 
tejun
