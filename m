Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbZIYRJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbZIYRJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 13:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZIYRJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 13:09:05 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:56865 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbZIYRJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 13:09:03 -0400
Date: Fri, 25 Sep 2009 22:38:51 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Shaohua Li <shaohua.li@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [v6 PATCH 0/7]: cpuidle/x86/POWER: Cleanup idle power
	management code in x86, cleanup drivers/cpuidle/cpuidle.c and
	introduce cpuidle to POWER.
Message-ID: <20090925170851.GA28191@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090922112526.GA7788@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090922112526.GA7788@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-22 16:55:27]:
Hi,

I have done the following experiments and have posted the results
below.


Average of 5 iterations:
------------------------------------------------------------------------------
------------------------------------------------------------------------------

Kernbench make -j16 results on a
16 core x86 machine _with_deep_sleep_ support (C1,C2,C3)


Without the patches applied			With the patches applied


	31.8s						30.4s

------------------------------------------------------------------------------
------------------------------------------------------------------------------


Kernbench make -j8 results on a
8 core x86 machine _without_deep_sleep_ support (only mwait)


Without the patches applied			With the patches applied


	20.2s						20.4s

------------------------------------------------------------------------------
------------------------------------------------------------------------------

Kernbench make -j8 results on a 8 core _dedicated_lpar_pSeries_ machine


Without the patches applied                     With the patches applied


	4m, 37s						4m, 36s

------------------------------------------------------------------------------
------------------------------------------------------------------------------

Please let me know if any other kind of testing is necessary.


Based on the feedback, I will post out the next iteration with a few
minor bug fixes.


thanks,
arun
