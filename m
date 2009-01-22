Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbZAVJpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbZAVJpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZAVJpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:45:09 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38252 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbZAVJpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:45:08 -0500
Date: Thu, 22 Jan 2009 01:45:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jkosina@suse.cz
Subject: Re: [PATCH] rcu: remove duplicate CONFIG_RCU_CPU_STALL_DETECTOR
Message-ID: <20090122094505.GF6290@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4977CFFE.2020405@cn.fujitsu.com> <20090122071705.GC6290@linux.vnet.ibm.com> <20090122083023.GA7438@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122083023.GA7438@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 09:30:23AM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Thu, Jan 22, 2009 at 09:46:38AM +0800, Lai Jiangshan wrote:
> > > 
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

Works for me!

							Thanx, Paul
