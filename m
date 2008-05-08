Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbYEHGBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbYEHGBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbYEHGBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:01:07 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56540 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbYEHGBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:01:05 -0400
Date: Thu, 8 May 2008 11:41:25 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080508061125.GC3644@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1210039590.3453.18.camel@ymzhang> <20080506115207.GA24862@linux.vnet.ibm.com> <20080507173357.GA4424@linux.vnet.ibm.com> <1210223914.3453.102.camel@ymzhang> <20080508054047.GD32729@linux.vnet.ibm.com> <1210226013.3453.113.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210226013.3453.113.camel@ymzhang>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 01:53:33PM +0800, Zhang, Yanmin wrote:
> > One more thing if you can try out, please set the shares for other users
> > to 2 except for the one which is running the benchmark. You can set it
> > at /sys/kernel/uids/<uid>/cpu_share
> I might try. There are only 2 users active in my system, root for background processes and mine
> for the testing. In the other hand, I kill most backgroud services when starting testing. So
> it might not have help.

The other combination that I am interested to know is when:

CONFIG_FAIR_GROUP_SCHED=y and CONFIG_CGROUP_SCHED=y

[i.e cgroup based scheduling rather than uid based scheduling. Former
should result in only one group at bootup]

I will also try to get some numbers with this combination.

-- 
Regards,
vatsa
