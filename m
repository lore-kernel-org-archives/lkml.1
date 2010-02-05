Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab0BEFmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 00:42:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:35572 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0BEFmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 00:42:37 -0500
Message-ID: <4B6BB13C.2090108@kernel.org>
Date: Fri, 05 Feb 2010 14:48:44 +0900
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
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 05:42:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/05/2010 02:16 PM, Stephen Rothwell wrote:
> The percpu tree currently in linux-next
> (git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git#for-next)
> contains a patch to remove the "per_cpu_" prefix from percpu variables
> followed by  a set of patches to annotate all the percpu variables (and
> accessing variables) with a __percpu tag to put them into a separate
> sparse name space.  These latter patches are causing some merge conflicts
> with a couple of trees (and will most likely cause more before the merge
> window).  A solution to this is for you to accept the patch below into
> your tree now and then the annotating patches can be sent to the
> respective maintainers directly.
> 
> Of course, this assumes that you will accept the percpu changes during
> the next merge window (and they are not completely without controversy)
> and the proponents actually submit them :-).
> 
> What do you think?
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 5 Feb 2010 16:09:11 +1100
> Subject: [PATCH] percpu: add __percpu for sparse
> 
> This is to make the annotation of percpu variables during the next merge
> window less painfull.
> 
> Extracted from a patch by Rusty Russell.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

I agree that this would be the cleanest way to integrate things.
Thanks for doing this.  If this gets in, I'll send individual patches
to respective maintainers.

Acked-by: Tejun Heo <tj@kernel.org>

For reference, the thread which contains the annoation patches is

  http://lkml.org/lkml/2010/1/25/107

Thanks.

-- 
tejun
