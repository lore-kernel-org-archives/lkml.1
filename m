Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbYJILuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbYJILuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 07:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbYJILup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 07:50:45 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58151 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972AbYJILuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 07:50:44 -0400
Date: Thu, 9 Oct 2008 04:50:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rjw@sisk.pl, dipankar@in.ibm.com, tglx@linuxtronix.de
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
Message-ID: <20081009115041.GC6628@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009010846.GA10188@linux.vnet.ibm.com> <48EDA2A6.9070707@cn.fujitsu.com> <20081009065529.GC24560@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009065529.GC24560@one.firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 08:55:29AM +0200, Andi Kleen wrote:
> > In this case, why not define it as:
> > static char buf[20*NR_CPUS + 100];
> 
> Actually you should near never use NR_CPUS now but always num_possible_cpus()
> (or even num_online_cpus()) Using NR_CPUS can lead to extreme waste
> of memory on kernels which are compiled for 4096 CPUs for example.
> 
> And with num_possible_cpus() kmalloc is needed.

OK, new one on me!  Thank you for the pointer!

							Thanx, Paul
