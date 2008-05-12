Return-Path: <linux-kernel-owner+w=401wt.eu-S1759940AbYELC1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbYELC1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 22:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbYELC1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 22:27:42 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49880 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbYELC1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 22:27:41 -0400
Date: Mon, 12 May 2008 08:07:58 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080512023758.GN3612@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1210039590.3453.18.camel@ymzhang> <20080506115207.GA24862@linux.vnet.ibm.com> <20080507173357.GA4424@linux.vnet.ibm.com> <1210223914.3453.102.camel@ymzhang> <20080508054047.GD32729@linux.vnet.ibm.com> <1210226013.3453.113.camel@ymzhang> <20080508061125.GC3644@linux.vnet.ibm.com> <20080509155240.GH3612@linux.vnet.ibm.com> <1210556351.3151.2.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210556351.3151.2.camel@ymzhang>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 09:39:10AM +0800, Zhang, Yanmin wrote:
> I'm confused by these conceptions.

Sorry if the recommended options was not clear.

> Would you like to tell me the exact config options
> you want to turn on?
> 
> Options in my config file(both 2.6.25 and 2.6.26-rc1):
> 
> # CONFIG_CGROUPS is not set
> CONFIG_GROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_USER_SCHED=y
> # CONFIG_CGROUP_SCHED is not set

Retain this config for 2.6.25.

For 2.6.26-rc1, turn OFF CONFIG_USER_SCHED and turn ON CONFIG_CGROUP_SCHED i.e

# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y

[Note that above options are mutually exclusive i.e you cannot set both
of them to y]

>From my experiments, results of 2.6.25 (with CONFIG_USER_SCHED=y) are
same as 2.6.26-rc1 (with CONFIG_CGROUP_SCHED=y).

It'd be great if you could confirm the same in your environment.

-- 
Regards,
vatsa
