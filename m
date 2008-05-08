Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbYEHFVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbYEHFVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 01:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYEHFV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 01:21:26 -0400
Received: from mga10.intel.com ([192.55.52.92]:59014 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753098AbYEHFVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 01:21:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,453,1204531200"; 
   d="scan'208";a="562110797"
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <1210181657.6525.7.camel@lappy.programming.kicks-ass.net>
References: <1210039590.3453.18.camel@ymzhang>
	 <20080507091748.GB30645@elte.hu>
	 <1210181657.6525.7.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Thu, 08 May 2008 13:20:12 +0800
Message-Id: <1210224012.3453.105.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 19:34 +0200, Peter Zijlstra wrote:
> On Wed, 2008-05-07 at 11:17 +0200, Ingo Molnar wrote:
> > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > 
> > > Comparing with 2.6.25, volanoMark has big regression with kernel 
> > > 2.6.26-rc1. It's about 50% on my 8-core stoakley, 16-core tigerton, 
> > > and Itanium Montecito.
> > > 
> > > With bisect, I located below patch.
> > 
> > thanks Yanmin, i've queued up your patch that reverts this change.
> 
> Is this really needed now that GROUP_SCHED defaults to 'n' ?
> 
> Yanmin, this is with GROUP_SCHED=y, right or is this without?
With GROUP_SCHED=y.

I remember a similiar patch was merged into 2.6.25-rc1 and I found the similiar volanoMark
regression, then you reverted it. Why to add it back to 2.6.26-rc1?

-yanmin


