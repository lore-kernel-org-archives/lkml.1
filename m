Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbZAVJsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbZAVJsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZAVJsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:48:38 -0500
Received: from styx.suse.cz ([82.119.242.94]:35745 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753250AbZAVJsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:48:37 -0500
Date: Thu, 22 Jan 2009 10:48:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: remove duplicate CONFIG_RCU_CPU_STALL_DETECTOR
In-Reply-To: <20090122083023.GA7438@elte.hu>
Message-ID: <alpine.LNX.1.10.0901221047580.5377@jikos.suse.cz>
References: <4977CFFE.2020405@cn.fujitsu.com> <20090122071705.GC6290@linux.vnet.ibm.com> <20090122083023.GA7438@elte.hu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009, Ingo Molnar wrote:

> > > Impact: remove the old CONFIG_RCU_CPU_STALL_DETECTOR
> > > 
> > > tree_rcu introduce CONFIG_RCU_CPU_STALL_DETECTOR again.
> > > 
> > > These two are the same exactly except:
> > > the old one "depends on CLASSIC_RCU"
> > > the new one "depends on CLASSIC_RCU || TREE_RCU"
> > > 
> > > This patch remove the old one.
> > 
> > Good eyes!
> > 
> > However, Jiri Kosina has already queued this up for the trivial tree:
> > 
> > 	http://lkml.org/lkml/2009/1/15/218
> 
> i've queued it up in tip/core/urgent, as we already touch the RCU Kconfig 
> structure there.

No problem, I have dropped that.

-- 
Jiri Kosina
SUSE Labs
