Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbZCMAh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbZCMAh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZCMAhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:37:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47348 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZCMAhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:37:10 -0400
Date: Fri, 13 Mar 2009 01:36:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Frans Pop <elendil@planet.nl>,
       "thellstrom@vmware.com" <thellstrom@vmware.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: Re: [PATCH] VM, x86, PAT: Change implementation of
	is_linear_pfn_mapping
Message-ID: <20090313003654.GA19544@elte.hu>
References: <498B5ADE.3090602@vmware.com> <200903120645.44515.elendil@planet.nl> <20090312185918.GA22421@linux-os.sc.intel.com> <200903122130.23860.elendil@planet.nl> <1236898090.4529.80.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236898090.4529.80.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

> On Thu, 2009-03-12 at 13:30 -0700, Frans Pop wrote:
> > On Thursday 12 March 2009, Pallipadi, Venkatesh wrote:
> > > OK, Looking more at the code, I now understand how the patch from
> > > yday resulted in the oops you saw. Here goes my nth attempt at solving
> > > this problem. Can you please test this patch.
> > 
> > System has been running stable for almost an hour now with pat enabled, so 
> > it looks like the problem is solved.
> > 
> > FYI, with early .29 RCs I had the following when running VirtualBox:
> > kernel: WARNING: at arch/x86/mm/pat.c:620 reserve_pfn_range+0x5b/0x26d()
> > 
> > After be03d9e80220 (which probably fixed that) VirtualBox could no longer 
> > be loaded at all with pat enabled, but with this patch added VirtualBox 
> > runs perfectly again.
> 
> That's great news :-).
> 
> Ingo: considering the history of this patch, can you let this 
> cook in your tree for a week or so and then push towards 
> upstream-git (and .29 stable if .29 is out by then).

Could you please update the commit log with the Reported-by and 
Tested-by tags from Frans, and resend it anew into this thread 
with a changed subject line?

	Ingo
