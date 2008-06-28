Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbYF1M0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbYF1M0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYF1MZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:25:58 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44113 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbYF1MZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:25:58 -0400
Date: Sat, 28 Jun 2008 13:22:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
       balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080628122237.GA22099@srcf.ucam.org>
References: <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com> <48640C04.9020600@firstfloor.org> <1214516584.12265.10.camel@twins.programming.kicks-ass.net> <48641A7D.6080204@firstfloor.org> <1214553090.2801.7.camel@twins.programming.kicks-ass.net> <48649F84.4090501@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48649F84.4090501@firstfloor.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 10:06:28AM +0200, Andi Kleen wrote:

> Ok distcc is a special case, but it doesn't apply to a lot of other
> processes (do you really want your CPU to crank up for "updatedb" or
> beagle or some backup job for example?)

If something's CPU-bound, then you almost certainly want to speed the 
CPU up. There's no power advantage to leaving it at a low frequency. I'd 
be surprised if things like beagle or updatedb are CPU-bound, though.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
