Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbYFSHWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbYFSHWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 03:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYFSHWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 03:22:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:42543 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbYFSHWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 03:22:42 -0400
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot
	transaction	abstraction
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4859E8AF.30306@goop.org>
References: <b020e42384197b824320.1213615800@localhost>
	 <1213831403.8011.24.camel@pasglop> <4859A149.9090004@goop.org>
	 <4859A528.1010107@goop.org>
	 <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org>
	 <1213835971.8011.54.camel@pasglop>  <4859E8AF.30306@goop.org>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 17:20:31 +1000
Message-Id: <1213860031.8011.65.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Which architecture are you interested in?  If it isn't x86, you can 
> probably get anything past Linus ;)
> 
> I'll do some measurements to see what effect the batchable 
> ptep_set_wrprotect() has on native.  If it's significant, I'll propose 
> making it conditional on CONFIG_PARAVIRT.

Oh, I mostly think about powerpc, I just wondered if I could re-use
your new stuff in that context. Mostly idle thoughts at this stage, I
haven't looked seriously.

I have an old patch set to batch forks (and mprotect etc...) TLB
invalidations (which is what I really want to batch on powerpc, more
than the actual PTE changes) that involves subtle changes to the
batching mechanisms etc... but it has issues and would need to be
reworked before merging.

It's something that's been in the back of my mind or the bottom of my
TODO list for some time, but I never quite found the bandwidth to go
back to it.

Cheers,
Ben.

