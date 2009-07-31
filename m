Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbZGaQo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbZGaQo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 12:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZGaQoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 12:44:25 -0400
Received: from fifo99.com ([67.223.236.141]:40477 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbZGaQoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 12:44:25 -0400
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
From: Daniel Walker <dwalker@fifo99.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1249029241.3322.2.camel@work-vm>
References: <200907291717.n6THHG6f001426@d06av06.portsmouth.uk.ibm.com>
	 <20090730125351.6f16e9ec@skybase> <1248958173.6046.32.camel@desktop>
	 <20090730150456.6c87b997@skybase>  <1248961750.6046.35.camel@desktop>
	 <1248974187.3331.6.camel@work-vm>  <1248977320.6046.66.camel@desktop>
	 <1248987409.3374.5.camel@localhost>  <1249018430.6046.73.camel@desktop>
	 <1249029241.3322.2.camel@work-vm>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 09:44:34 -0700
Message-Id: <1249058674.6046.92.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-31 at 01:34 -0700, john stultz wrote:

> 
> Again, distro kernels. Users can't rebuild them without possibly losing
> the support they've paid for, and often recompiling them can cause 3rd
> party drivers to fail to work (some distros preserve kernel ABI
> stability between minor releases). Waiting 6 months or two years for the
> next release where everything is fixed upstream isn't going to make
> users happy.

It wouldn't need to be a module. The distro would update the kernel as
needed.. Just the act of loading an unauthorized kernel module would
potentially invalidate any distro support someone might get.. Distro's
typically provide backported fixes also.

> Now, with most hardware vendors implementing decent HPET/ACPI PM
> counters, maybe this case is more me reacting to a bad situation I had
> to deal with in the past then what we can realistically expect in the
> future. But given hardware designers like to break assumptions to
> squeeze out performance or features, I'd suspect there will be future
> situations where having some extra flexibility would be valuable.
> 
> Imaginary example: broken BIOS has incorrect HPET freq and the TSCs are
> not in sync. Savvy IT dude finds the problem, copies the HPET driver,
> names it hpet-fix and hard codes the proper HPET freq in. Sets the
> rating higher then HPET, builds it as a module and loads it on the
> affected hardware.

The IT guy more than likely would need to rebuild the kernel multiple
times to discover what the problem was .. In the end the distro would
push a fix for this to mainline, and provide a new kernel for the distro
users with a backported fix.

If there a potential for a clocksource to have some type of issue like
what you describe for the HPET, wouldn't it be easier to have all those
as tunable boot args or sysfs options .. 

Daniel

