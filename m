Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbXK3JHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbXK3JHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 04:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXK3JH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 04:07:29 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:37740 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXK3JH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 04:07:26 -0500
Date: Fri, 30 Nov 2007 14:37:08 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       dipankar@in.ibm.com, ego@in.ibm.com, mathieu.desnoyers@polymtl.ca,
       mingo@elte.hu
Subject: Re: [PATCH 0/2] Markers Implementation for RCU Tracing
Message-ID: <20071130090708.GA8208@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20071129184128.GA26466@in.ibm.com> <20071130013605.GK9059@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130013605.GK9059@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 05:36:05PM -0800, Paul E. McKenney wrote:
> On Fri, Nov 30, 2007 at 12:11:28AM +0530, K. Prasad wrote:
> > Hi,
> > 	Please review the ensuing set of patches which convert the
> > existing RCU tracing mechanism for Preempt RCU and RCU Boost into
> > markers.
> > 
> > These patches are based upon the 2.6.24-rc2-rt1 kernel tree.
> > 
> > Along with marker transition, the RCU Tracing infrastructure has also
> > been modularised to be built as a kernel module, thereby enabling
> > runtime changes to the RCU Tracing infrastructure.
> > 
> > Patch [1/2] - Patch that converts the Preempt RCU tracing in
> > rcupreempt.c into markers.
> > 
> > Patch [1/2] - Patch that converts the Preempt RCU Boost tracing in
> > rcupreempt-boost.c into markers.
> 
> Looks good to me, though I do not pretend to understand the markers
> implementation.  I presume that the markers implementation forces the
> varargs usage -- though the markers do seem quite a bit nicer in allowing
> the formatting to be specified more naturally.
> 

Paul,
	Thanks for the quick review.
Yes, varargs are required for marker handlers even with fixed set of
arguments.

Ingo,
	Can you please include these patches in your rt patchset?

Thanks,
K.Prasad

