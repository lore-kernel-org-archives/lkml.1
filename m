Return-Path: <linux-kernel-owner+w=401wt.eu-S1762049AbYEUFUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762049AbYEUFUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 01:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYEUFTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 01:19:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:36224 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752775AbYEUFTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 01:19:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18lNboGGDElkQ7vTqWEqco3JKWTcAM3QwNbZaAbQr
	JDuveCSAnxE+Tt
Subject: Re: hackbench regression with 2.6.26-rc2 on tulsa machine
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1211345650.3177.247.camel@ymzhang>
References: <1211270946.3177.236.camel@ymzhang>
	 <1211275352.24305.6.camel@marge.simson.net>
	 <1211345650.3177.247.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Date: Wed, 21 May 2008 07:19:48 +0200
Message-Id: <1211347188.4829.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-21 at 12:54 +0800, Zhang, Yanmin wrote:
> On Tue, 2008-05-20 at 11:22 +0200, Mike Galbraith wrote:

> > Do you still have group scheduling enabled?
> Yes.
> CONFIG_GROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_USER_SCHED=y
> # CONFIG_CGROUP_SCHED is not set
> 
> >   If so, can you turn it off
> > and try again?  (when in doubt, grasp at any straw within reach;)
> I reran the test for dozeons of times.
> 1) Background processes have impact on the result and cause result to fluctuate with 8~9 seconds;
> 2) After turning off most services (background processes), the result looks stable;
> 3) I tested both 2.6.26-rc1 and 2.6.26-rc2 with ﻿CONFIG_GROUP_SCHED=n. the first one's result
> is about 30 seconds and the second one's result is about 31 seconds. So ﻿CONFIG_GROUP_SCHED is the key.

Thanks a bunch for re-testing.

	-Mike

