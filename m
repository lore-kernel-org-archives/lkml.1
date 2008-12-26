Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYLZOYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYLZOYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 09:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbYLZOX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 09:23:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42045 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbYLZOX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 09:23:56 -0500
Date: Fri, 26 Dec 2008 15:22:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org, ralf@linux-mips.org,
       kernel@wantstofly.org, hskinnemoen@atmel.com, cooloney@kernel.org,
       tony.luck@intel.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       jwboyer@linux.vnet.ibm.com, mporter@kernel.crashing.org,
       grant.likely@secretlab.ca, paulus@samba.org, benh@kernel.crashing.org,
       dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
       lethal@linux-sh.org, hpa@zytor.com
Subject: Re: [PATCH -tip] Switch arm defconfig files from
	CONFIG_CLASSIC_RCU to CONFIG_TREE_RCU.
Message-ID: <20081226142236.GA24249@elte.hu>
References: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com> <12299911471985-git-send-email-paulmck@linux.vnet.ibm.com> <20081223142542.GC29151@elte.hu> <20081225083611.GA14968@elte.hu> <20081225093301.GB27896@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225093301.GB27896@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Thu, Dec 25, 2008 at 09:36:11AM +0100, Ingo Molnar wrote:
> > 
> > below is the fix for another small buglet that hits architectures that do 
> > not include kernel/Kconfig.preempt.
> 
> What is needed to let all architectures include Kconfig.preempt?
> We should not advertise preemption if not supported,
> but we could do this by a simple Kconfig symbol:
> 
> config HAVE_PREEMPT
> 	bool
> 
> And let all architectures that supports preemption do:
> 
> config "ARCH"
> 	select HAVE_PREEMPT
> 
> But maybe there is a simpler solution

Since a preemptive kernel is not supported by all architectures, there has 
to be per arch ways to express this - i.e. i think your solution is the 
cleanest.

	Ingo
