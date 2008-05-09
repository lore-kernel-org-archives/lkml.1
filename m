Return-Path: <linux-kernel-owner+w=401wt.eu-S1763274AbYEIPo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763274AbYEIPo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYEIPoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:44:18 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34459 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYEIPoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:44:18 -0400
Date: Fri, 9 May 2008 21:24:39 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080509155439.GI3612@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1210039590.3453.18.camel@ymzhang> <20080506115207.GA24862@linux.vnet.ibm.com> <20080507173357.GA4424@linux.vnet.ibm.com> <1210223914.3453.102.camel@ymzhang> <20080508054047.GD32729@linux.vnet.ibm.com> <1210226013.3453.113.camel@ymzhang> <20080508061125.GC3644@linux.vnet.ibm.com> <20080509155240.GH3612@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509155240.GH3612@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 09:22:40PM +0530, Srivatsa Vaddagiri wrote:
> 2.6.26-rc1 + patches in Ingo's tree [1] as of Fri morning IST (abt 8 hrs
> before) (with CONFIG_CGROUP_SCHED)

Reference:
	
1.  git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-fixes.git

Yamin,
	I request you just compare 2.6.25 (CONFIG_USER_SCHED)
performance with 2.6.26-rc1 (CONFIG_CGROUP_SCHED) performance. They
should be same (as they use the same definition of cpu load).

-- 
Regards,
vatsa
