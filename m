Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbYDAUqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbYDAUqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759434AbYDAUpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:45:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40721 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324AbYDAUpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:45:51 -0400
Date: Tue, 1 Apr 2008 13:45:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for 2.6.25] Markers - use synchronize_sched()
Message-ID: <20080401204542.GA8558@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080331131609.GA22207@Krystal> <20080401133017.9484a35b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401133017.9484a35b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 01:30:17PM -0700, Andrew Morton wrote:
> On Mon, 31 Mar 2008 09:16:09 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Use synchronize_sched before calling call_rcu in CONFIG_PREEMPT_RCU until we
> > have call_rcu_sched and rcu_barrier_sched in mainline. It will slow down the
> > marker operations in CONFIG_PREEMPT_RCU, but it fixes the current race against
> > the preempt_disable/enable() protected code paths.
> 
> A better changelog would have described the bug which is being fixed.
> 
> > Paul, is this ok ? It would be good to get this in for 2.6.25 final.
> 
> Paul seems to have nodded off.  I'll merge it.

Paul seems to have fat-fingered the earlier message.  But he does see the
message adding this to -mm, and the patch looks good to me.

							Thanx, Paul
