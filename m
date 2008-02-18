Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYBRHjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYBRHjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYBRHjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:39:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:57624 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753661AbYBRHjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:39:43 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Y3DQa/osYQICxiJSqD8Fg+fqL92gxTuhL/mvAAe
	HmzHNEtiG5mJ+q
Subject: Re: 2.6.24-git4+ regression
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, aneesh.kumar@in.ibm.com
In-Reply-To: <20080218042831.GJ30201@elte.hu>
References: <20080130135609.GA5100@ics.muni.cz>
	 <20080214165551.GA21963@linux.vnet.ibm.com>
	 <20080217202642.GA4327@ics.muni.cz>  <20080218042831.GJ30201@elte.hu>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 08:38:24 +0100
Message-Id: <1203320304.26269.3.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-18 at 05:28 +0100, Ingo Molnar wrote: 
> * Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:
> 
> > On Thu, Feb 14, 2008 at 10:25:51PM +0530, Srivatsa Vaddagiri wrote:
> > > The patch is against 2.6.25-rc1. I would request you to check for
> > > difference it makes with CONFIG_FAIR_GROUP_SCHED and
> > > CONFIG_FAIR_USER_SCHED turned on.
> > 
> > well, I tried the patch against 2.6.25-rc2-git1. It seems to be better 
> > but without CONFIG_FAIR_GROUP_SCHED it is still even better.
> 
> could you try latest sched-devel.git, does it behave any better?

Here, it does not.  It seems fine without CONFIG_FAIR_GROUP_SCHED.

Oddity:  mainline git with Srivatsa's test patch improves markedly, and
using sched_latency_ns and sched_wakeup_granularity_ns, I can tweak the
regression into submission.  With sched-devel, I cannot tweak it away
with or without the test patch.  Dunno how useful that info is.

	-Mike

