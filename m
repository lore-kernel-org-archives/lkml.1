Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbZCTUnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbZCTUnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZCTUmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:42:53 -0400
Received: from www.tglx.de ([62.245.132.106]:43811 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbZCTUmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:42:52 -0400
Date: Fri, 20 Mar 2009 21:41:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] kbuild: work around distcc/icecc madness
In-Reply-To: <20090320193334.GA19501@elte.hu>
Message-ID: <alpine.LFD.2.00.0903202123310.29264@localhost.localdomain>
References: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain> <20090320092234.GA3792@elte.hu> <alpine.LFD.2.00.0903201127360.29264@localhost.localdomain> <20090320185917.GB6224@elte.hu> <alpine.LFD.2.00.0903202010250.29264@localhost.localdomain>
 <20090320193334.GA19501@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Ingo Molnar wrote:
> i dont do anything weird. i use:
> 
> CROSS_COMPILE='distcc 
> /opt/crosstool/gcc-4.2.2-glibc-2.3.6/i686-unknown-linux-gnu/bin/i686-unknown-linux-gnu-'
> 
> host compiler was never supposed to be the same in terms of 
> capability as target compiler.

Hmm. Then something else is going wrong. The kernel build system
checks the target compiler not the host one.

Is your distcc setup using the same compilers on all your machines in
the build cluster ?

Thanks,

	tglx
