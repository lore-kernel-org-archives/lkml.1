Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYHADLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYHADLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 23:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYHADL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 23:11:26 -0400
Received: from mga10.intel.com ([192.55.52.92]:57104 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752064AbYHADL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 23:11:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,290,1215414000"; 
   d="scan'208";a="366962319"
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: miaox@cn.fujitsu.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4892765F.5020401@cn.fujitsu.com>
References: <1217474425.25608.150.camel@ymzhang>
	 <1217489463.25608.157.camel@ymzhang>  <1217489949.8157.78.camel@twins>
	 <1217490560.25608.168.camel@ymzhang> <1217551154.25608.169.camel@ymzhang>
	 <4892765F.5020401@cn.fujitsu.com>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 11:08:37 +0800
Message-Id: <1217560117.25608.171.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-08-01 at 10:35 +0800, Miao Xie wrote:
> on 2008-8-1 8:39 Zhang, Yanmin wrote:
> [snip]
> >> The regression I reported exists on:
> >> 1) 8-core+HT(totally 16 logical processor) tulsa: 40% regression with volano, 8% with oltp;
> >> 2) 8-core+HT Montvale Itanium: 9% regression with volano; 8% with oltp;
> >> 3) 16-core tigerton: %70 with volano, %18 with oltp;
> >> 4) 8-core stoakley: %15 with oltp, testing failed with volanoMark.
> >>
> >> So the issues are popular on different architectures.
> > I know kernel needs the features and it might not be a good idea to reject them over and over again.
> > I will collect more data on tigerton and try to optimize it.
> 
> Could you tell me the exact config options? the same with last time?
Yes.

> 
> as follows:
> 
> # CONFIG_CGROUPS is not set
> CONFIG_GROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_USER_SCHED=y
> # CONFIG_CGROUP_SCHED is not set


