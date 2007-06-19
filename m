Return-Path: <linux-kernel-owner+w=401wt.eu-S1762555AbXFSBob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762555AbXFSBob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 21:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758319AbXFSBoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 21:44:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39880 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653AbXFSBoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 21:44:21 -0400
Date: Tue, 19 Jun 2007 07:22:32 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       suresh.b.siddha@intel.com, pwil3058@bigpond.net.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070619015232.GE17865@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070615144535.GA12078@elte.hu> <20070615151452.GC9301@linux.vnet.ibm.com> <20070615195545.GA28872@elte.hu> <20070616011605.GH9301@linux.vnet.ibm.com> <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com> <20070618151215.GA9750@linux.vnet.ibm.com> <Pine.LNX.4.64.0706180948250.4751@schroedinger.engr.sgi.com> <20070618173558.GA17865@linux.vnet.ibm.com> <Pine.LNX.4.64.0706181054530.6596@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706181054530.6596@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 10:59:21AM -0700, Christoph Lameter wrote:
> I think the check in idle_balance needs to be modified.
> 
> If the domain *does not* have SD_BALANCE_NEWIDLE set then
> next_balance must still be set right. Does this patch fix it?

Is the ->next_balance calculation in idle_balance() necessary at all?
rebalance_domains() would have programmed ->next_balance anyway, based
on the nearest next_balance point of all (load-balance'able) domains.
By repeating that calculation in idle_balance, are we covering any corner case?

-- 
Regards,
vatsa
