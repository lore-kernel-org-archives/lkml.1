Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbXEYMdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbXEYMdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbXEYMdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:33:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55288 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbXEYMdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:33:35 -0400
Date: Fri, 25 May 2007 18:11:41 +0530
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
Message-ID: <20070525124141.GI6157@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070523164859.GA6595@in.ibm.com> <3d8471ca0705231112rfac9cfbt9145ac2da8ec1c85@mail.gmail.com> <20070523183824.GA7388@elte.hu> <4654BF88.3030404@yahoo.fr> <20070525074500.GD6157@in.ibm.com> <20070525082951.GA25280@elte.hu> <20070525105641.GA12114@in.ibm.com> <20070525111140.GA24942@elte.hu> <20070525112849.GG6157@in.ibm.com> <20070525120536.GB7186@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525120536.GB7186@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 02:05:36PM +0200, Ingo Molnar wrote:
> great. Btw., could you please keep the "up to this point there should be 
> no behavioral change in CFS" fundamental splitup of your patches -

sure ..basically the changes required in CFS core is the introduction of two
structures - struct sched_entity and struct lrq and generalization of
cfs routines to operate on these structures rather than on
task_struct/rq structures directly.

In the first split, I will ensure that this generalization is applied
only to tasks (which represents reorganization of core with no
behavioral/functional change in scheduler) and in a subsequent split/patch I 
will apply the generalization to uids also (which will add group fairness 
aspect to scheduler), as you require.

Thanks for your feedback so far!

> that way i can look at the core changes (and possibly apply them) without 
> having to consider the uid based changes (which do change behavior and 
> which need more upstream buy-in).

-- 
Regards,
vatsa
