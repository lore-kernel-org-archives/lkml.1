Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbYELEml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbYELEml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYELEmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:42:33 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41339 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYELEmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:42:32 -0400
Date: Mon, 12 May 2008 10:22:46 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080512045246.GP3612@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080506115207.GA24862@linux.vnet.ibm.com> <20080507173357.GA4424@linux.vnet.ibm.com> <1210223914.3453.102.camel@ymzhang> <20080508054047.GD32729@linux.vnet.ibm.com> <1210226013.3453.113.camel@ymzhang> <20080508061125.GC3644@linux.vnet.ibm.com> <20080509155240.GH3612@linux.vnet.ibm.com> <1210556351.3151.2.camel@ymzhang> <20080512023758.GN3612@linux.vnet.ibm.com> <1210563200.3151.10.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1210563200.3151.10.camel@ymzhang>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 11:33:20AM +0800, Zhang, Yanmin wrote:
> To make the testing faster, I changed some parameters of volanoMark.
> The result of 2.6.26-rc1(﻿CONFIG_CGROUP_SCHED=y) is about 2%~3% less than the one of
> 2.6.25 (﻿CONFIG_USER_SCHED=y).

This for confirming my observation. It seems much better than the 50% regression
reported earlier (with 2.6.26-rc1 and CONFIG_USER_SCHED).

Ideally we should get same results with CONFIG_USER_SCHED also (in
2.6.26-rc1). That needs some work in load balance code. Till that is
tackled, IMHO we can retain all the current code by either:

1. Disabling CONFIG_GROUP_SCHED (or better)
2. Enable CONFIG_GROUP_SCHED and CONFIG_CGROUP_SCHED

Ingo/Peter, What's your opinion?

-- 
Regards,
vatsa
