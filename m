Return-Path: <linux-kernel-owner+w=401wt.eu-S1422828AbXBALuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422828AbXBALuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422830AbXBALuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:50:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422828AbXBALue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:50:34 -0500
Date: Thu, 1 Feb 2007 12:53:36 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org
Subject: Re: [patch 0/9] x86_64: reliable TSC-based gettimeofday
Message-ID: <20070201115336.GC13277@opteron.random>
References: <20070201095952.589234000@jet.suse.cz> <200702011220.59484.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011220.59484.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 12:20:59PM +0100, Andi Kleen wrote:
> I think a better way to do this would be to define a new CLOCK_THREAD_MONOTONOUS
> (or better name) timer for clock_gettime(). 
> 
> [and my currently stalled vdso patches that implement clock_gettime
> as a vsyscall]
> 
> Then also an application could easily use it with LD_PRELOAD

I think a prctl to enable the non monothone mode is better than any
LD_PRELOAD trick.
