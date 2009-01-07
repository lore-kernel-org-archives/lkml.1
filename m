Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbZAGFni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbZAGFni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 00:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZAGFn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 00:43:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:60871 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZAGFn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:43:29 -0500
Subject: Re: powerpc: introduce asm/swab.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
In-Reply-To: <alpine.LFD.2.00.0901062108440.3057@localhost.localdomain>
References: <200901070400.n0740Ore002063@hera.kernel.org>
	 <1231303340.14860.61.camel@pasglop> <1231304552.14860.72.camel@pasglop>
	 <alpine.LFD.2.00.0901062108440.3057@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 16:43:17 +1100
Message-Id: <1231306997.14860.76.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 21:11 -0800, Linus Torvalds wrote:
> That's the same patch I just sent out (but you changed comments too), so I 
> obviously agree. 
> 
> x86 didn't see this (even in 32-bit mode) because it doesn't use that odd 
> __SWAB_64_THRU_32__ case, but does the 64-bit swab with native code.
> 
> Can you also verify that it works for you (not just compiles), just so 
> that I can commit it?

I'll try asap, just had to go home, and I have less build horsepower
here ;-)

Cheers,
Ben.


