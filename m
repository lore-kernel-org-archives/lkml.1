Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbXEaEJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbXEaEJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbXEaEJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:09:14 -0400
Received: from holomorphy.com ([66.93.40.71]:54399 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbXEaEJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:09:13 -0400
Date: Wed, 30 May 2007 21:09:26 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>,
       Nick Piggin <nickpiggin@yahoo.com.au>, ckrm-tech@lists.sourceforge.net,
       Balbir Singh <balbir@in.ibm.com>, efault@gmx.de,
       linux-kernel@vger.kernel.org, tingy@cs.umass.edu,
       Kirill Korotaev <dev@sw.ru>, kernel@kolivas.org, tong.n.li@intel.com,
       containers@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070531040926.GH6909@holomorphy.com>
References: <20070525082951.GA25280@elte.hu> <4656DF0C.9090306@sw.ru> <20070525153450.GA4679@in.ibm.com> <46570C70.4050209@sw.ru> <20070525180850.GA26884@in.ibm.com> <46577CA6.8000807@bigpond.net.au> <20070526154112.GA31925@holomorphy.com> <20070530171405.GA21062@in.ibm.com> <20070530201359.GD6909@holomorphy.com> <20070531032657.GA823@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531032657.GA823@in.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 01:13:59PM -0700, William Lee Irwin III wrote:
>> The step beyond was to show how nice numbers can be done with all that
>> hierarchical task grouping so they have global effects instead of
>> effects limited to the scope of the narrowest grouping hierarchy
>> containing the task. I had actually assumed the weighting and
>> flattening bits were already in your plans from some other post you
>> made and was building upon that.

On Thu, May 31, 2007 at 08:56:57AM +0530, Srivatsa Vaddagiri wrote:
> I would definitely be willing to try out any experiments you think of,
> esp those that allow the hierarchy to be flattened. atm fair_key
> calculation (in the context of cfs) seem to be the biggest challenge to 
> surmount for this to work.

It's not all that tricky. The ->fair_key computations are already
parametrized on load weights. The "task weights" here are just what
Linux calls "load weight," so we're largely done once task weights
are calculated.

The tricky part (if any) is essentially what you've already got nailed
down, that is, creating and manipulating the accounting objects for the
task groups or whatever you're calling them.


-- wli
