Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbZACLW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbZACLW4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 06:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZACLWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 06:22:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:53291 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752982AbZACLWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 06:22:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+QNPlFM8eQ5LTbTh0PVZs7QWKMvs80yTJVHTKqPL
	26oWnW8fd55Aan
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
From: Mike Galbraith <efault@gmx.de>
To: svaidy@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090103101626.GA4301@dirshya.in.ibm.com>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com>
	 <28c262360812291543ia322a13g6af854a685ce7632@mail.gmail.com>
	 <20081230024819.GA23301@balbir.in.ibm.com> <20081230062139.GA30038@elte.hu>
	 <20081230180722.GA29060@dirshya.in.ibm.com>
	 <20090102072600.GA13412@dirshya.in.ibm.com>
	 <20090102221630.GF17240@elte.hu> <1230967765.5257.6.camel@marge.simson.net>
	 <20090103101626.GA4301@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 12:22:41 +0100
Message-Id: <1230981761.27180.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-03 at 15:46 +0530, Vaidyanathan Srinivasan wrote:
> * Mike Galbraith <efault@gmx.de> [2009-01-03 08:29:25]:
> 
> > On Fri, 2009-01-02 at 23:16 +0100, Ingo Molnar wrote:
> > 
> > > Mike, would you be interesting in having a look at sched_mc=2 as a 
> > > kernel-wide default - and give it your blessing if you find it to be a net 
> > > improvement for the various performance and interactivity tests you do?
> > 
> > Sure.
> 
> Thanks Mike and Ingo.  I will be glad to help with test and benchmarks
> on the platforms that I have access.
> 
> I am presently working on sysbench.

The testing I can do is rather severely limited since I have only one
Q6600.  I butchered mc_capable() to use what I can though, ie see if
SD_BALANCE_NEWIDLE still harms tbench and mysql+oltp.  I think that's
about all I can do on my wee box.

	-Mike

