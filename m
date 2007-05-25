Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbXEYLU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbXEYLU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbXEYLUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:20:50 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53751 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbXEYLUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:20:49 -0400
Date: Fri, 25 May 2007 16:58:49 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>,
       Nick Piggin <nickpiggin@yahoo.com.au>, efault@gmx.de,
       kernel@kolivas.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, pwil3058@bigpond.net.au, tingy@cs.umass.edu,
       tong.n.li@intel.com, wli@holomorphy.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070525112849.GG6157@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070523164859.GA6595@in.ibm.com> <3d8471ca0705231112rfac9cfbt9145ac2da8ec1c85@mail.gmail.com> <20070523183824.GA7388@elte.hu> <4654BF88.3030404@yahoo.fr> <20070525074500.GD6157@in.ibm.com> <20070525082951.GA25280@elte.hu> <20070525105641.GA12114@in.ibm.com> <20070525111140.GA24942@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525111140.GA24942@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 01:11:40PM +0200, Ingo Molnar wrote:
> > I was planning on reusing smpnice concepts here, with the difference 
> > that we balance group weights across CPU in addition to total weight 
> > of CPUs.
> 
> ok, that would be (much) simpler that any explicit vcpu approach. Do you 
> plan to add this next?

sure, after i first cleanup current group changes a bit. Hopefully I can
send you first version of smp support by early next week.

-- 
Regards,
vatsa
