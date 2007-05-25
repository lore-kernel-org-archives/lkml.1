Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbXEYMH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbXEYMH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbXEYMHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:07:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36847 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbXEYMHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:07:19 -0400
Date: Fri, 25 May 2007 14:05:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>,
       Nick Piggin <nickpiggin@yahoo.com.au>, efault@gmx.de,
       kernel@kolivas.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, pwil3058@bigpond.net.au, tingy@cs.umass.edu,
       tong.n.li@intel.com, wli@holomorphy.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070525120536.GB7186@elte.hu>
References: <20070523164859.GA6595@in.ibm.com> <3d8471ca0705231112rfac9cfbt9145ac2da8ec1c85@mail.gmail.com> <20070523183824.GA7388@elte.hu> <4654BF88.3030404@yahoo.fr> <20070525074500.GD6157@in.ibm.com> <20070525082951.GA25280@elte.hu> <20070525105641.GA12114@in.ibm.com> <20070525111140.GA24942@elte.hu> <20070525112849.GG6157@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525112849.GG6157@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:

> On Fri, May 25, 2007 at 01:11:40PM +0200, Ingo Molnar wrote:
> > > I was planning on reusing smpnice concepts here, with the difference 
> > > that we balance group weights across CPU in addition to total weight 
> > > of CPUs.
> > 
> > ok, that would be (much) simpler that any explicit vcpu approach. Do you 
> > plan to add this next?
> 
> sure, after i first cleanup current group changes a bit. Hopefully I 
> can send you first version of smp support by early next week.

great. Btw., could you please keep the "up to this point there should be 
no behavioral change in CFS" fundamental splitup of your patches - that 
way i can look at the core changes (and possibly apply them) without 
having to consider the uid based changes (which do change behavior and 
which need more upstream buy-in).

	Ingo
