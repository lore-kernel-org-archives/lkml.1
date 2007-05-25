Return-Path: <linux-kernel-owner+w=401wt.eu-S1761092AbXEYLMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761092AbXEYLMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbXEYLMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:12:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49172 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbXEYLMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:12:31 -0400
Date: Fri, 25 May 2007 13:11:40 +0200
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
Message-ID: <20070525111140.GA24942@elte.hu>
References: <20070523164859.GA6595@in.ibm.com> <3d8471ca0705231112rfac9cfbt9145ac2da8ec1c85@mail.gmail.com> <20070523183824.GA7388@elte.hu> <4654BF88.3030404@yahoo.fr> <20070525074500.GD6157@in.ibm.com> <20070525082951.GA25280@elte.hu> <20070525105641.GA12114@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525105641.GA12114@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:

> On Fri, May 25, 2007 at 10:29:51AM +0200, Ingo Molnar wrote:
> > btw., what are you thoughts about SMP?
> 
> I was planning on reusing smpnice concepts here, with the difference 
> that we balance group weights across CPU in addition to total weight 
> of CPUs.

ok, that would be (much) simpler that any explicit vcpu approach. Do you 
plan to add this next?

	Ingo
