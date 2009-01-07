Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbZAGFL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbZAGFL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 00:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZAGFLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 00:11:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbZAGFLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:11:46 -0500
Date: Tue, 6 Jan 2009 21:11:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: powerpc: introduce asm/swab.h
In-Reply-To: <1231304552.14860.72.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0901062108440.3057@localhost.localdomain>
References: <200901070400.n0740Ore002063@hera.kernel.org>  <1231303340.14860.61.camel@pasglop> <1231304552.14860.72.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Benjamin Herrenschmidt wrote:
> 
> Even if fixing that to use __swab32() instead, then it fails because
> this is defined after it's used. I worked around it using fswab in
> there instead.

That's the same patch I just sent out (but you changed comments too), so I 
obviously agree. 

x86 didn't see this (even in 32-bit mode) because it doesn't use that odd 
__SWAB_64_THRU_32__ case, but does the 64-bit swab with native code.

Can you also verify that it works for you (not just compiles), just so 
that I can commit it?

			Linus
