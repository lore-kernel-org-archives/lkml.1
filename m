Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYIYOFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYIYOFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYIYOF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:05:28 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42956 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbYIYOF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:05:27 -0400
Date: Thu, 25 Sep 2008 07:05:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.com
Subject: Re: [PATCH, RFC] v6 scalable classic RCU implementation
Message-ID: <20080925140506.GA6725@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20080925072607.GA20249@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925072607.GA20249@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 09:26:07AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > +config RCU_CPU_STALL_DETECTOR
> > +	bool "Check for stalled CPUs delaying RCU grace periods"
> > +	depends on CLASSIC_RCU || TREE_RCU
> > +	default n
> > +	help
> > +	  This option causes RCU to printk information on which
> > +	  CPUs are delaying the current grace period, but only when
> > +	  the grace period extends for excessive time periods.
> > +
> > +	  Say Y if you want RCU to perform such checks.
> > +
> > +	  Say N if you are unsure.
> 
> could you please send this bit separately, even if rcutree isnt finished 
> yet? Seems like a quite useful debug feature.

Good point -- I guess I do need to implement the CLASSIC_RCU piece of
this in any case.

							Thanx, Paul
