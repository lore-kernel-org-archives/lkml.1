Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbXDDXAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbXDDXAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 19:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXDDXAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 19:00:00 -0400
Received: from ozlabs.org ([203.10.76.45]:41771 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbXDDW77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:59:59 -0400
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack
	pagetable entries
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200704041756.35016.ak@suse.de>
References: <20070402055652.610711908@goop.org>
	 <200704041347.42822.ak@suse.de> <4613C828.2030604@goop.org>
	 <200704041756.35016.ak@suse.de>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 08:59:09 +1000
Message-Id: <1175727549.12230.583.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 17:56 +0200, Andi Kleen wrote:
> On Wednesday 04 April 2007 17:45:44 Jeremy Fitzhardinge wrote:
> > Andi Kleen wrote:
> > > Why is there a difference for null syscall? I had assumed we patched all the 
> > > fast path cases relevant there. Do you have an idea where it comes from?
> > 
> > Sure.  There's indirect calls for things like sti/cli/iret.  It goes
> > back to native speed when you patch the real instructions inline.
> 
> I was talking about the patched case. It seemed to be a little slower
> too, but in theory it shouldn't have been, no? 

You'll still have the damage inflicted on gcc's optimizer, though.

Rusty.

