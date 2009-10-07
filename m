Return-Path: <linux-kernel-owner+w=401wt.eu-S934056AbZJGNVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056AbZJGNVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933727AbZJGNVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:21:43 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:56451 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933539AbZJGNVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:21:42 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [v7 PATCH 0/7]: cpuidle/x86/POWER: Cleanup idle power
 management code in x86, cleanup drivers/cpuidle/cpuidle.c and introduce
 cpuidle to POWER.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, arun@linux.vnet.ibm.com,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20091007114719.GH6818@balbir.in.ibm.com>
References: <20091006152421.GA7278@linux.vnet.ibm.com>
	 <20091006163521.GA10425@linux.vnet.ibm.com>
	 <1254852279.17055.2.camel@laptop>
	 <20091007112648.GC7646@dirshya.in.ibm.com>
	 <20091007114719.GH6818@balbir.in.ibm.com>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 15:24:17 +0200
Message-Id: <1254921857.26976.249.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 17:17 +0530, Balbir Singh wrote:

> > The objective of the refactoring is to have a single common idle
> > routine management framework (remove pm_idle) and we have it done
> > through cpuidle registration framework.  We can incrementally remove
> > the per-cpu registration later easily by splitting the cpuidle_driver
> > structure.
> >
> 
> Yes, incremental refactoring makes the most sense from the do not
> break as you refactor point of view.

Sure,.. but I would have though getting rid of the per-cpu-ish-ness
would have made the latter patches in this series easier. But maybe I'm
lazy ;-)

Let me go over the patches one more time, but they do look ok.


