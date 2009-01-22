Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbZAVIaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbZAVIaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbZAVIaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:30:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38595 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZAVIaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:30:30 -0500
Date: Thu, 22 Jan 2009 09:30:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: remove duplicate CONFIG_RCU_CPU_STALL_DETECTOR
Message-ID: <20090122083023.GA7438@elte.hu>
References: <4977CFFE.2020405@cn.fujitsu.com> <20090122071705.GC6290@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122071705.GC6290@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Thu, Jan 22, 2009 at 09:46:38AM +0800, Lai Jiangshan wrote:
> > 
> > Impact: remove the old CONFIG_RCU_CPU_STALL_DETECTOR
> > 
> > tree_rcu introduce CONFIG_RCU_CPU_STALL_DETECTOR again.
> > 
> > These two are the same exactly except:
> > the old one "depends on CLASSIC_RCU"
> > the new one "depends on CLASSIC_RCU || TREE_RCU"
> > 
> > This patch remove the old one.
> 
> Good eyes!
> 
> However, Jiri Kosina has already queued this up for the trivial tree:
> 
> 	http://lkml.org/lkml/2009/1/15/218

i've queued it up in tip/core/urgent, as we already touch the RCU Kconfig 
structure there.

	Ingo
