Return-Path: <linux-kernel-owner+w=401wt.eu-S1946404AbXBQEFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946404AbXBQEFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 23:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946408AbXBQEFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 23:05:34 -0500
Received: from ozlabs.org ([203.10.76.45]:43528 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946404AbXBQEFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 23:05:34 -0500
Subject: Re: [Xen-devel] Re: [patch 14/21] Xen-paravirt: Add XEN config
	options and disable unsupported config options.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Keir Fraser <keir@xensource.com>, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>, xen-devel@lists.xensource.com,
       Andi Kleen <ak@muc.de>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Hand <steven.hand@cl.cam.ac.uk>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <45D58531.4010808@vmware.com>
References: <C1FB336B.98D6%keir@xensource.com> <45D58531.4010808@vmware.com>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 15:04:35 +1100
Message-Id: <1171685075.18876.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 02:19 -0800, Zachary Amsden wrote:
> Doesn't stop_machine_run already take care of getting you out of all 
> kernel threads?  So you can only be sleeping, not preempted, in which 
> case, this might not be an issue?

No, stop_machine only protects against preempt-disabled regions.

I thought about making that particularly hammer bigger, but noone had
needed it yet.  It would simply require a runtime way of disabling
further preemption and flushing preempted threads (AFAICT there can be
no deadlock issues with this).

Rusty.


