Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYEHFUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYEHFUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 01:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYEHFTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 01:19:48 -0400
Received: from mga05.intel.com ([192.55.52.89]:3167 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752978AbYEHFTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 01:19:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,453,1204531200"; 
   d="scan'208";a="562110140"
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <20080507173357.GA4424@linux.vnet.ibm.com>
References: <1210039590.3453.18.camel@ymzhang>
	 <20080506115207.GA24862@linux.vnet.ibm.com>
	 <20080507173357.GA4424@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 08 May 2008 13:18:34 +0800
Message-Id: <1210223914.3453.102.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 23:03 +0530, Dhaval Giani wrote:
> On Tue, May 06, 2008 at 05:22:07PM +0530, Dhaval Giani wrote:
> > On Tue, May 06, 2008 at 10:06:30AM +0800, Zhang, Yanmin wrote:
> > > Comparing with 2.6.25, volanoMark has big regression with kernel 2.6.26-rc1.
> > > It's about 50% on my 8-core stoakley, 16-core tigerton, and Itanium Montecito.
> > > 
> > > With bisect, I located below patch.
> > > 
> > > 18d95a2832c1392a2d63227a7a6d433cb9f2037e is first bad commit
> > > commit 18d95a2832c1392a2d63227a7a6d433cb9f2037e
> > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Date:   Sat Apr 19 19:45:00 2008 +0200
> > > 
> > >     sched: fair-group: SMP-nice for group scheduling
> > >     
> > >     Implement SMP nice support for the full group hierarchy.
> > > 
> > > If I reverse the patch with resolving some conflictions, volanoMark result could
> > > be restored completely.
> > > 
> > 
> > ok, that's bad. Let's get vatsa and Ingo also involved.
> > 
> 
> Just to confirm, do you still have a performance regression with
> !group_sched?
I just tried it with CONFIG_GROUP_SCHED=n a moment ago. The regression becomes less than 3%.



