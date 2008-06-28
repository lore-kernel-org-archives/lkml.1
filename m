Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYF1M5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYF1M5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYF1M5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:57:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60127 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYF1M5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:57:06 -0400
Date: Sat, 28 Jun 2008 13:53:49 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
       balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080628125349.GB22099@srcf.ucam.org>
References: <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com> <48640C04.9020600@firstfloor.org> <1214516584.12265.10.camel@twins.programming.kicks-ass.net> <48641A7D.6080204@firstfloor.org> <1214553090.2801.7.camel@twins.programming.kicks-ass.net> <48649F84.4090501@firstfloor.org> <20080628122237.GA22099@srcf.ucam.org> <48663032.6010207@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48663032.6010207@firstfloor.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2008 at 02:36:02PM +0200, Andi Kleen wrote:

> For example if you're in a data center at a specific operating point and
> you would need to crank up the air condition at significant power cost it might
> be well better overall to force all servers to a lower operating point
> and avoid that.

Sure, there are cases where you have additional constraints. But within 
those constraints, you probably want to run as fast as possible.

> That said in general you all should have complained when ondemand behaviour
> was introduced.

ignore_nice seems to be set to 0 by default?

> Also it's unclear that the general "race to idle" heuristic really
> applies to the case of the "keep sockets idle" power optimization
> that started this thread.
> 
> Usually package C states bring much more than core C states
> and keeping another package completely idle saves likely
> more power than the power cost of running something a little
> bit slower on a package that is already busy on another core.

I'd agree with that.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
