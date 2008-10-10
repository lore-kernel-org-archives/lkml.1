Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbYJJLsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbYJJLsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYJJLsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:48:15 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47190 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbYJJLsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:48:14 -0400
Date: Fri, 10 Oct 2008 04:48:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rjw@sisk.pl, dipankar@in.ibm.com, tglx@linuxtronix.de
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
Message-ID: <20081010114811.GB6633@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009010846.GA10188@linux.vnet.ibm.com> <48EDA2A6.9070707@cn.fujitsu.com> <20081009065529.GC24560@one.firstfloor.org> <48EDAD55.2000502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EDAD55.2000502@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 03:05:57PM +0800, Lai Jiangshan wrote:
> Andi Kleen wrote:
> >> In this case, why not define it as:
> >> static char buf[20*NR_CPUS + 100];
> > 
> > Actually you should near never use NR_CPUS now but always num_possible_cpus()
> > (or even num_online_cpus()) Using NR_CPUS can lead to extreme waste
> > of memory on kernels which are compiled for 4096 CPUs for example.
> > 
> > And with num_possible_cpus() kmalloc is needed.
> > 
> > -Andi
> 
> I thought the default value of NR_CPUS is 32.
> 
> if NR_CPUS is too large, I think using seq_file is good idea,
> and rcuclassic_trace_mutex is not need too.

I never have used seq_file, to be honest.  I would welcome a patch from
you applying it to my rcucb and rcudata patch set.

							Thanx, Paul
