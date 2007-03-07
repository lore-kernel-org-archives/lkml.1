Return-Path: <linux-kernel-owner+w=401wt.eu-S1161054AbXCGAox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161054AbXCGAox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161065AbXCGAow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:44:52 -0500
Received: from ozlabs.org ([203.10.76.45]:53281 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161051AbXCGAot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:44:49 -0500
Subject: Re: Xen & VMI?
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Nakajima, Jun" <jun.nakajima@intel.com>,
       virtualization <virtualization@lists.osdl.org>,
       Roland McGrath <roland@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
In-Reply-To: <20070306203712.GC21736@elte.hu>
References: <45ED82D9.6050204@codemonkey.ws>
	 <8FFF7E42E93CC646B632AB40643802A80229779B@scsmsx412.amr.corp.intel.com>
	 <20070306203712.GC21736@elte.hu>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 11:44:06 +1100
Message-Id: <1173228246.4644.85.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 21:37 +0100, Ingo Molnar wrote:
> maybe i shouldnt call it 'VMI' but 'the paravirt ABI'. I dont mind if 
> it's the Xen ABI or the VMWare ABI or a mesh of the two - everyone can 
> map their own internals to that /one/ ABI.

I think it's an excellent aim, but it's *HARD*.  I rejected this
approach earlier because I'm just not smart enough.  (Yet?)

The Linux side is fairly stable.  The hardware side is changing, and the
hypervisor side is changing.  This means the ABI will churn fairly fast.
The hypervisors are very different, which means the ABI will be very
wide.

We could start with VMI and try to support Xen, KVM and lguest.  It
would at least give us a better idea of the scope of the problem.  But
IMHO it's a *huge* job.

Rusty.


