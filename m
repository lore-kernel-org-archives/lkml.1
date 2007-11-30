Return-Path: <linux-kernel-owner+w=401wt.eu-S934548AbXK3BgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548AbXK3BgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 20:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761825AbXK3BgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 20:36:09 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39371 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760917AbXK3BgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 20:36:07 -0500
Date: Thu, 29 Nov 2007 17:36:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "K. Prasad" <prasad@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       mathieu.desnoyers@polymtl.ca, mingo@elte.hu
Subject: Re: [PATCH 0/2] Markers Implementation for RCU Tracing
Message-ID: <20071130013605.GK9059@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071129184128.GA26466@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129184128.GA26466@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 12:11:28AM +0530, K. Prasad wrote:
> Hi,
> 	Please review the ensuing set of patches which convert the
> existing RCU tracing mechanism for Preempt RCU and RCU Boost into
> markers.
> 
> These patches are based upon the 2.6.24-rc2-rt1 kernel tree.
> 
> Along with marker transition, the RCU Tracing infrastructure has also
> been modularised to be built as a kernel module, thereby enabling
> runtime changes to the RCU Tracing infrastructure.
> 
> Patch [1/2] - Patch that converts the Preempt RCU tracing in
> rcupreempt.c into markers.
> 
> Patch [1/2] - Patch that converts the Preempt RCU Boost tracing in
> rcupreempt-boost.c into markers.

Looks good to me, though I do not pretend to understand the markers
implementation.  I presume that the markers implementation forces the
varargs usage -- though the markers do seem quite a bit nicer in allowing
the formatting to be specified more naturally.

							Thanx, Paul
