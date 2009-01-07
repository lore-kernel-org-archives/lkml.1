Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZAGFj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZAGFj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 00:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZAGFjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 00:39:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZAGFjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:39:15 -0500
Date: Wed, 7 Jan 2009 00:39:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: powerpc: introduce asm/swab.h
Message-ID: <20090107053913.GA21687@goodmis.org>
References: <200901070400.n0740Ore002063@hera.kernel.org> <1231303340.14860.61.camel@pasglop> <1231304552.14860.72.camel@pasglop> <alpine.LFD.2.00.0901062108440.3057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901062108440.3057@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 09:11:42PM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 7 Jan 2009, Benjamin Herrenschmidt wrote:
> > 
> > Even if fixing that to use __swab32() instead, then it fails because
> > this is defined after it's used. I worked around it using fswab in
> > there instead.
> 
> That's the same patch I just sent out (but you changed comments too), so I 
> obviously agree. 
> 
> x86 didn't see this (even in 32-bit mode) because it doesn't use that odd 
> __SWAB_64_THRU_32__ case, but does the 64-bit swab with native code.
> 
> Can you also verify that it works for you (not just compiles), just so 
> that I can commit it?

I'm the one that originally told Ben about this breaking the PPC32 build.
His patch compiles on my PPC32 box. I just rebooted with the new kernel
and it boots.

Tested-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

