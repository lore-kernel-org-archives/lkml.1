Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbYELFpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbYELFpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 01:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYELFpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 01:45:10 -0400
Received: from mga10.intel.com ([192.55.52.92]:53149 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751101AbYELFpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 01:45:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,471,1204531200"; 
   d="scan'208";a="563495585"
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: vatsa@linux.vnet.ibm.com
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1210568533.3151.13.camel@ymzhang>
References: <20080506115207.GA24862@linux.vnet.ibm.com>
	 <20080507173357.GA4424@linux.vnet.ibm.com>
	 <1210223914.3453.102.camel@ymzhang>
	 <20080508054047.GD32729@linux.vnet.ibm.com>
	 <1210226013.3453.113.camel@ymzhang>
	 <20080508061125.GC3644@linux.vnet.ibm.com>
	 <20080509155240.GH3612@linux.vnet.ibm.com>
	 <1210556351.3151.2.camel@ymzhang>
	 <20080512023758.GN3612@linux.vnet.ibm.com>
	 <1210563200.3151.10.camel@ymzhang>
	 <20080512045246.GP3612@linux.vnet.ibm.com>
	 <1210568533.3151.13.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 12 May 2008 13:43:01 +0800
Message-Id: <1210570981.3151.18.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-12 at 13:02 +0800, Zhang, Yanmin wrote:
> On Mon, 2008-05-12 at 10:22 +0530, Srivatsa Vaddagiri wrote:
> > On Mon, May 12, 2008 at 11:33:20AM +0800, Zhang, Yanmin wrote:
> > > To make the testing faster, I changed some parameters of volanoMark.
> > > The result of 2.6.26-rc1(﻿CONFIG_CGROUP_SCHED=y) is about 2%~3% less than the one of
> > > 2.6.25 (﻿CONFIG_USER_SCHED=y).
One more testing:
volanoMark result of 2.6.25 (﻿﻿CONFIG_CGROUP_SCHED=y) is about 6%~7% better than the one
of ﻿2.6.26-rc1(﻿CONFIG_CGROUP_SCHED=y).

> A quick update:
> With 2.6.26-rc2 (﻿CONFIG_USER_SCHED=y), volanoMa﻿rk result on my 8-core stoakley
> is about 10% worse than the one of 2.6.26-rc1.
> 
> > 
> > This for confirming my observation. It seems much better than the 50% regression
> > reported earlier (with 2.6.26-rc1 and CONFIG_USER_SCHED).
> > 
> > Ideally we should get same results with CONFIG_USER_SCHED also (in
> > 2.6.26-rc1). That needs some work in load balance code. Till that is
> > tackled, IMHO we can retain all the current code by either:
> > 
> > 1. Disabling CONFIG_GROUP_SCHED (or better)
> > 2. Enable CONFIG_GROUP_SCHED and CONFIG_CGROUP_SCHED
> > 
> > Ingo/Peter, What's your opinion?


