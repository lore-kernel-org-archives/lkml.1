Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYL2XoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYL2XoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 18:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYL2XoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 18:44:00 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:23860 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYL2Xn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 18:43:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RlujOxGxr0IGdRjssbxvg2IDFEJqrYAHrDjhgKF9/HhZondeB7U2oFi2bWsrUlom9G
         75nA34U1SgBpss6zBbtEnqC2wbNks6m4ysiS35yPdQN5SwcyD/LVOP9Ue70VyQZ6z8DZ
         qCpUVrG6C4wdR2GZS2JDGVWjNnVZLfOZLQLHY=
Message-ID: <28c262360812291543ia322a13g6af854a685ce7632@mail.gmail.com>
Date: Tue, 30 Dec 2008 08:43:58 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Suresh B Siddha" <suresh.b.siddha@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>, "Dipankar Sarma" <dipankar@in.ibm.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, "Gautham R Shenoy" <ego@in.ibm.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "David Collier-Brown" <davecb@sun.com>,
       "Tim Connors" <tconnors@astro.swin.edu.au>,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       "Gregory Haskins" <gregory.haskins@gmail.com>,
       "Pavel Machek" <pavel@suse.cz>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081218175313.29812.4781.stgit@drishya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vaidyanathan.
It's very late reponse. :(

> Results:
> --------
>
> Basic functionality of the code has not changed and the power vs
> performance benefits for kernbench are similar to the ones posted
> earlier.
>
> KERNBENCH Runs: make -j4 on a x86 8 core, dual socket quad core cpu
> package system
>
> SchedMC Run Time     Package Idle    Energy  Power
> 0       81.68        52.83% 54.71%  1.00x J 1.00y W
> 1       80.70        36.62% 70.11%  0.95x J 0.96y W
> 2       74.95        19.53% 85.92%  0.90x J 0.98y W
>
> The results are marginally better than the previous version of the
> patch series which could be within the test variation.
>
> Please feel free to test, and let me know your comments and feedback.
> I will post more experimental results with various benchmarks.

Your result is very interesting.
level 2 is more fast and efficient of power.

What's major contributor to use less time in level 2?
I think it's cache bounce is less time than old.
Is right ?

I want to test SCHED_MC but I don't know what you use to benchmark about power.
How do I get the data about 'Package, Idle, Energy, Power'?

-- 
Kinds regards,
MinChan Kim
