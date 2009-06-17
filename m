Return-Path: <linux-kernel-owner+w=401wt.eu-S1762270AbZFQOiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270AbZFQOiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbZFQOiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:38:06 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36797 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbZFQOiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:38:04 -0400
Date: Wed, 17 Jun 2009 07:38:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>, Rusty Russel <rusty@rustcorp.com.au>,
       Nathan Lynch <ntl@pobox.com>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Subject: Re: [RFD PATCH 0/4] cpu: Bulk CPU Hotplug support.
Message-ID: <20090617143804.GA6767@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com> <20090615232318.74b099a6.akpm@linux-foundation.org> <20090616080715.GB7961@dirshya.in.ibm.com> <1245223977.13761.21576.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245223977.13761.21576.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 09:32:57AM +0200, Peter Zijlstra wrote:
> On Tue, 2009-06-16 at 13:37 +0530, Vaidyanathan Srinivasan wrote:
> > * Andrew Morton <akpm@linux-foundation.org> [2009-06-15 23:23:18]:
> > 
> > > On Tue, 16 Jun 2009 11:08:39 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:
> > > 
> > > > Currently on a ppc64 box with 16 CPUs, the time taken for
> > > > a individual cpu-hotplug operation is as follows.
> > > > 
> > > >     # time echo 0 > /sys/devices/system/cpu/cpu2/online
> > > >     real    0m0.025s
> > > >     user    0m0.000s
> > > >     sys     0m0.002s
> > > > 
> > > >     # time echo 1 > /sys/devices/system/cpu/cpu2/online
> > > >     real    0m0.021s
> > > >     user    0m0.000s
> > > >     sys     0m0.000s
> > > 
> > > Surprised.  Do people really online and offline CPUs frequently enough
> > > for this to be a problem?
> > 
> > Certainly not for hardware faults or hardware replacement, but
> > cpu-hotplug interface is useful for changing system configuration to
> > meet different objectives like
> > 
> > * Reduce system capacity to reduce average power and reduce heat
> > 
> > * Increasing number of cores and threads in a CPU package is leading
> >   to multiple cpu offline/online operations for any perceivable effect
> > 
> > * Dynamically change CPU configurations in virtualized environments
> 
> I tend to agree with Andrew, if any of those things are done frequent
> enough that the hotplug performance matter you're doing something mighty
> odd.

Boot speedup?

							Thanx, Paul
