Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbXCWStQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbXCWStQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 14:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbXCWStQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 14:49:16 -0400
Received: from mga07.intel.com ([143.182.124.22]:11889 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753326AbXCWStP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 14:49:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,320,1170662400"; 
   d="scan'208"; a="201686755:sNHT839938813"
Subject: Re: RSDL 0.31 causes slowdown
From: Tim Chen <tim.c.chen@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
To: Con Kolivas <ckolivas@gmail.com>
Cc: ck@vds.kolivas.org, linux-kernel@vger.kernel.org, kernel@kolivas.org,
       wli@holomorphy.com, suresh.b.siddha@intel.com, arjan@infradead.org
In-Reply-To: <8cd998d50703221940naec0905y56ec708eb11b81a2@mail.gmail.com>
References: <1174598506.23795.62.camel@localhost.localdomain>
	 <8cd998d50703221940naec0905y56ec708eb11b81a2@mail.gmail.com>
Content-Type: text/plain
Organization: Intel
Date: Fri, 23 Mar 2007 09:57:30 -0800
Message-Id: <1174672650.23795.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 13:40 +1100, Con Kolivas wrote:

> 
> Volanomark is a purely yield() semantic dependant workload (as
> discussed many times previously). In the earlier form of RSDL I
> softened the effect of sched_yield but other changes since then have
> made that softness bordering on a noop. Obviously when sched_yield is
> relied upon that will not be enough. Extending the rr interval simply
> makes the yield slightly more effective and is not the proper
> workaround. Since expiration of arrays is a regular frequent
> occurrence in RSDL then changing yield semantics back to expiration
> should cause a massive improvement in these values, without making the
> yields as long as in mainline. It's impossible to know exactly what
> the final result will be since java uses this timing sensitive yield
> for locking but we can improve it drastically from this. I'll make a
> patch soon to change yield again.
> 

Con, 

The new RSDL 0.33 has fully recovered the loss in performance for
Volanomark.  The throughput for Volanomark is at the same level as
mainline 2.6.21-rc4 kernel.

Tim
