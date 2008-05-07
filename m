Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbYEGRe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbYEGRe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYEGReP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:34:15 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:46332 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbYEGReM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:34:12 -0400
Date: Wed, 7 May 2008 23:03:57 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080507173357.GA4424@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1210039590.3453.18.camel@ymzhang> <20080506115207.GA24862@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506115207.GA24862@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 05:22:07PM +0530, Dhaval Giani wrote:
> On Tue, May 06, 2008 at 10:06:30AM +0800, Zhang, Yanmin wrote:
> > Comparing with 2.6.25, volanoMark has big regression with kernel 2.6.26-rc1.
> > It's about 50% on my 8-core stoakley, 16-core tigerton, and Itanium Montecito.
> > 
> > With bisect, I located below patch.
> > 
> > 18d95a2832c1392a2d63227a7a6d433cb9f2037e is first bad commit
> > commit 18d95a2832c1392a2d63227a7a6d433cb9f2037e
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Sat Apr 19 19:45:00 2008 +0200
> > 
> >     sched: fair-group: SMP-nice for group scheduling
> >     
> >     Implement SMP nice support for the full group hierarchy.
> > 
> > If I reverse the patch with resolving some conflictions, volanoMark result could
> > be restored completely.
> > 
> 
> ok, that's bad. Let's get vatsa and Ingo also involved.
> 

Just to confirm, do you still have a performance regression with
!group_sched?

-- 
regards,
Dhaval
