Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbZG0Pc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbZG0Pc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZG0Pcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:32:55 -0400
Received: from www.tglx.de ([62.245.132.106]:47118 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbZG0Pcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:32:55 -0400
Date: Mon, 27 Jul 2009 17:32:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: Daniel Walker <dwalker@fifo99.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Patch RFC 01/37] semaphore: Add DEFINE_SEMAPHORE, semaphore_init,
 semaphore_init_locked
In-Reply-To: <20090727152505.GB31597@infradead.org>
Message-ID: <alpine.LFD.2.00.0907271730540.2936@localhost.localdomain>
References: <20090726081459.455111897@linutronix.de> <20090726081553.328151390@linutronix.de> <1248649489.28841.11.camel@desktop> <20090727152505.GB31597@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, Christoph Hellwig wrote:

> On Sun, Jul 26, 2009 at 04:04:49PM -0700, Daniel Walker wrote:
> > Maybe you could introduce this _after_ you do the semaphore to
> > completion cleanup .. This init_locked is just adding a bunch of code
> > flux on top of that..
> 
> I agree.  For these 36 patches we should first check if they can
> be trivially converted to mutexes or completions and only change them
> away to the semaphore named initializers.

I have already converted some of the users to mutexes where it was
obvious. It's part of the series. 

Thanks,

	tglx
