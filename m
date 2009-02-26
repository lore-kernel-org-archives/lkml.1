Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZBZQDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZBZQDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZBZQDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:03:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:48826 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbZBZQDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:03:11 -0500
Subject: Re: [RFC PATCH 0/4] timers: framework for migration between CPU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, ego@in.ibm.com, tglx@linutronix.de,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arun@linux.vnet.ibm.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <20090226154526.GD352@elte.hu>
References: <20090220141415.GA27381@dirshya.in.ibm.com>
	 <20090220160737.GC11294@elte.hu> <20090220115745.43d202d6@infradead.org>
	 <20090220215318.GA30665@elte.hu> <20090223075521.GA3725@balbir.in.ibm.com>
	 <20090223091158.GJ9582@elte.hu> <20090223094850.GA10226@balbir.in.ibm.com>
	 <20090223103814.GB8817@dirshya.in.ibm.com> <20090223110725.GB17312@elte.hu>
	 <20090226085831.GA28397@in.ibm.com>  <20090226154526.GD352@elte.hu>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 17:02:49 +0100
Message-Id: <1235664169.4948.319.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 16:45 +0100, Ingo Molnar wrote:

> Yes - but that kind of policy should be coupled and expressed 
> via cpusets. /proc based irq_affinity is just a limited, 
> inflexible hack. All things IRQ partitioning should be handled 
> via cpusets - perhaps via the 'system sets' idea from Peter?

all we got out of that idea was the default_smp_affinity thing
in /proc/irq and a head-ache trying to work out silly details.

Maybe we ought to try again,..

