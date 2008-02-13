Return-Path: <linux-kernel-owner+w=401wt.eu-S1766009AbYBMJsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766009AbYBMJsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbYBMJsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:48:11 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:45859 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753728AbYBMJsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:48:04 -0500
Message-ID: <47B2BC2C.80100@linux.vnet.ibm.com>
Date: Wed, 13 Feb 2008 15:15:16 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: vatsa@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.25-rc1: volanoMark 45% regression
References: <1202895028.3027.27.camel@ymzhang>
In-Reply-To: <1202895028.3027.27.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin wrote:
> volanoMark has 45% regression with kernel 2.6.25-rc1 on my both 8-core
> stoakley and 16-core Tigerton.
> 
> I used bisect to locate below patch.
> 
> commit 58e2d4ca581167c2a079f4ee02be2f0bc52e8729
> Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Date:   Fri Jan 25 21:08:00 2008 +0100
> 
>     sched: group scheduling, change how cpu load is calculated
> 
> 
> 
> hackbench has about 30% regression on 16-core tigerton, but has about 10% improvement
> on 8-core stoakley.
> 
> In addition, tbench has about 6% regression on my 8-core stoakley and
> 25% regression on 16-core stoakley. Some other benchmarks, like netperf/aim7
> also have some regression. I will verify if they are all related to the
> patch.
> 
> -yanmin

Hi, Yamin,

Thanks for reporting the issue? Any chance we could getthe Oprofile output for
the run? The exact commandline and .config being used would also help.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
