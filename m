Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYFSAlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYFSAlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYFSAla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:41:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:42393 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbYFSAl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:41:29 -0400
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction
	abstraction
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org>
References: <b020e42384197b824320.1213615800@localhost>
	 <1213831403.8011.24.camel@pasglop> <4859A149.9090004@goop.org>
	 <4859A528.1010107@goop.org>
	 <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 10:39:31 +1000
Message-Id: <1213835971.8011.54.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 17:24 -0700, Linus Torvalds wrote:
> 
> On Wed, 18 Jun 2008, Jeremy Fitzhardinge wrote:
> >
> > Along the lines of:
> 
> Hell no. There's a reason we have a special set_wrprotect() thing. We can 
> do it more efficiently on native hardware by just clearing the bit 
> atomically. No need to do the cmpxchg games.

But we can't batch ... 

Ben.


