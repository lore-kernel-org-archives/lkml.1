Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab0BEHJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 02:09:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55934 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933247Ab0BEHJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 02:09:34 -0500
Date: Fri, 5 Feb 2010 08:09:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: upcoming percpu changes
Message-ID: <20100205070903.GA9320@elte.hu>
References: <20100205161648.086375b9.sfr@canb.auug.org.au>
 <4B6BB13C.2090108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6BB13C.2090108@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 02/05/2010 02:16 PM, Stephen Rothwell wrote:
> > The percpu tree currently in linux-next
> > (git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git#for-next)
> > contains a patch to remove the "per_cpu_" prefix from percpu variables
> > followed by  a set of patches to annotate all the percpu variables (and
> > accessing variables) with a __percpu tag to put them into a separate
> > sparse name space.  These latter patches are causing some merge conflicts
> > with a couple of trees (and will most likely cause more before the merge
> > window).  A solution to this is for you to accept the patch below into
> > your tree now and then the annotating patches can be sent to the
> > respective maintainers directly.
> > 
> > Of course, this assumes that you will accept the percpu changes during
> > the next merge window (and they are not completely without controversy)
> > and the proponents actually submit them :-).
> > 
> > What do you think?
> > 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Fri, 5 Feb 2010 16:09:11 +1100
> > Subject: [PATCH] percpu: add __percpu for sparse
> > 
> > This is to make the annotation of percpu variables during the next merge
> > window less painfull.
> > 
> > Extracted from a patch by Rusty Russell.
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> I agree that this would be the cleanest way to integrate things.
> Thanks for doing this.  If this gets in, I'll send individual patches
> to respective maintainers.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> For reference, the thread which contains the annoation patches is
> 
>   http://lkml.org/lkml/2010/1/25/107
> 
> Thanks.

Has the review feedback from Frederic and hpa been addressed? (and have they 
acked the solution?) That was the only controversial bit i remember.

Thanks,

	Ingo
