Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbYB2HLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbYB2HLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 02:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYB2HLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 02:11:11 -0500
Received: from mail.gmx.net ([213.165.64.20]:49015 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753619AbYB2HLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 02:11:10 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/afbYyprPagTrngw9xKh7yIOGlNmTvVUgHWIYqYk
	9MsKcVpc+Qzzst
Subject: Re: [PATCH] sched: revert load_balance_monitor()
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1204215191.4319.7.camel@homer.simson.net>
References: <1203942167.6242.142.camel@lappy>
	 <1203949799.4688.9.camel@homer.simson.net>
	 <20080225143518.GA29275@linux.vnet.ibm.com>
	 <1203950233.4688.11.camel@homer.simson.net>
	 <20080228132627.GA24096@elte.hu> <1204215191.4319.7.camel@homer.simson.net>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 08:11:05 +0100
Message-Id: <1204269065.6143.20.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 17:13 +0100, Mike Galbraith wrote:
> On Thu, 2008-02-28 at 14:26 +0100, Ingo Molnar wrote: 
> 
> > Mike, could you check whether today's sched-devel.git (which includes 
> > the full revert) works well for you? (with group scheduler enabled)
> 
> No, it's fairly lurchy with three root chew-max and one user chew-max
> running.  Moving the mouse around while they're running, I can see/feel
> the load, and max latency for the user chew-max quickly shoots to
> >500ms.

fair-group: single RQ approach was responsible for the lurchiness.  In
testing with that commit reverted, I've hit a couple anomalies.  Details
and mondo data sent offline.

	-Mike

