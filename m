Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbYBML6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbYBML6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYBML5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:57:52 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60957 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbYBML5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:57:51 -0500
Date: Wed, 13 Feb 2008 17:37:08 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.25-rc1: volanoMark 45% regression
Message-ID: <20080213120708.GA16231@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1202895028.3027.27.camel@ymzhang> <47B2BC2C.80100@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B2BC2C.80100@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 03:15:16PM +0530, Balbir Singh wrote:
> Zhang, Yanmin wrote:
> > volanoMark has 45% regression with kernel 2.6.25-rc1 on my both 8-core
> > stoakley and 16-core Tigerton.
> > 
> > I used bisect to locate below patch.
> > 
> > commit 58e2d4ca581167c2a079f4ee02be2f0bc52e8729
> > Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > Date:   Fri Jan 25 21:08:00 2008 +0100
> > 
> >     sched: group scheduling, change how cpu load is calculated
> > 
> > 
> > 
> > hackbench has about 30% regression on 16-core tigerton, but has about 10% improvement
> > on 8-core stoakley.
> > 
> > In addition, tbench has about 6% regression on my 8-core stoakley and
> > 25% regression on 16-core stoakley. Some other benchmarks, like netperf/aim7
> > also have some regression. I will verify if they are all related to the
> > patch.
> > 
> > -yanmin
> 
> Hi, Yamin,
> 
> Thanks for reporting the issue? Any chance we could getthe Oprofile output for
> the run? The exact commandline and .config being used would also help.

Yamin,
	I would also like to know against which previous version is this
regression being compared with. Is it 2.6.24? Did you have
CONFIG_FAIR_USER_SCHED enabled in both cases? It would also help to know if you
see the same regression with FAIR_GROUP_SCHED turned off.

-- 
Regards,
vatsa
