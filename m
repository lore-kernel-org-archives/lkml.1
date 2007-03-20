Return-Path: <linux-kernel-owner+w=401wt.eu-S1751056AbXCTR2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbXCTR2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbXCTR2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:28:31 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49322 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbXCTR2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:28:30 -0400
Date: Tue, 20 Mar 2007 10:27:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       David Miller <davem@davemloft.net>,
       virtualization@lists.linux-foundation.org, jbeulich@novell.com,
       jeremy@goop.org, xen-devel@lists.xensource.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       virtualization@lists.osdl.org, anthony@codemonkey.ws,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
In-Reply-To: <20070320180359.GB4286@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0703201022040.6730@woody.linux-foundation.org>
References: <20070319.120854.30182994.davem@davemloft.net>
 <20070319.204712.118947830.davem@davemloft.net> <m13b40wnrb.fsf@ebiederm.dsl.xmission.com>
 <200703201428.50564.ak@suse.de> <m1ircvswzz.fsf@ebiederm.dsl.xmission.com>
 <20070320174159.GA4286@bingen.suse.de> <Pine.LNX.4.64.0703200947501.6730@woody.linux-foundation.org>
 <20070320180359.GB4286@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Mar 2007, Andi Kleen wrote:
> 
> The code never did that. In fact many of the problems we had initially
> especially came out of that -- the fallback code that would handle
> this case wasn't fully correct.

I don't keep my emails any more, but you *never* fixed the problems in 
arch/*/kernel/traps.c.

Yes, the kernel/unwind.c issues generally got fixed. The infinite loops in 
the *callers* never did.

> Also frankly often your analysis about what went wrong was just
> incorrect.

Still in denial, I see.

Do you still claim that "the fallback position always did the right 
thing"? Despite the fact that the unwinder had sometimes *corrupted* the 
incoming information so much that the fallback position was the one that 
oopsed? And no, you didn't fix that.

And no, IT DID NOT use probe_kernel_address like you still claim.

Anyway, you work for Suse, I don't care what you do to the Suse kernel. 
Maybe it will get stable some day. Somehow, I doubt it. 

			Linus
