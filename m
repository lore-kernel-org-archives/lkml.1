Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbXEaFkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbXEaFkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 01:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757644AbXEaFke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 01:40:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60709 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbXEaFkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 01:40:33 -0400
Date: Thu, 31 May 2007 11:18:28 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, ckrm-tech@lists.sourceforge.net,
       Balbir Singh <balbir@in.ibm.com>, efault@gmx.de,
       linux-kernel@vger.kernel.org, tingy@cs.umass.edu,
       Peter Williams <pwil3058@bigpond.net.au>, kernel@kolivas.org,
       tong.n.li@intel.com, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, Kirill Korotaev <dev@sw.ru>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070531054828.GB663@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <4656DF0C.9090306@sw.ru> <20070525153450.GA4679@in.ibm.com> <46570C70.4050209@sw.ru> <20070525180850.GA26884@in.ibm.com> <46577CA6.8000807@bigpond.net.au> <20070526154112.GA31925@holomorphy.com> <20070530171405.GA21062@in.ibm.com> <20070530201359.GD6909@holomorphy.com> <20070531032657.GA823@in.ibm.com> <20070531040926.GH6909@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531040926.GH6909@holomorphy.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 09:09:26PM -0700, William Lee Irwin III wrote:
> It's not all that tricky. 

Hmm ..the fact that each task runs for a minimum of 1 tick seems to
complicate the matters to me (when doing group fairness given a single
level hierarchy). A user with 1000 (or more) tasks can be unduly
advantaged compared to another user with just 1 (or fewer) task because of this?

> The ->fair_key computations are already
> parametrized on load weights. The "task weights" here are just what
> Linux calls "load weight," so we're largely done once task weights
> are calculated.
> 
> The tricky part (if any) is essentially what you've already got nailed
> down, that is, creating and manipulating the accounting objects for the
> task groups or whatever you're calling them.

-- 
Regards,
vatsa
