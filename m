Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbXKGIqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbXKGIqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 03:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbXKGIqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 03:46:25 -0500
Received: from mx1.suse.de ([195.135.220.2]:36986 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414AbXKGIqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 03:46:24 -0500
Date: Wed, 7 Nov 2007 09:46:23 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Gregory Haskins <gregory.haskins.ml@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
Message-ID: <20071107084622.GB22719@wotan.suse.de>
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de> <4729E567.1050402@gmail.com> <alpine.LFD.0.999.0711010935060.3342@woody.linux-foundation.org> <20071101203526.293cd7f0@bree.surriel.com> <alpine.LFD.0.999.0711011819110.3342@woody.linux-foundation.org> <20071102064220.GC20967@wotan.suse.de> <20071102153332.GA28575@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102153332.GA28575@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 04:33:32PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > Anyway, if this can make its way to the x86 tree, I think it will get 
> > pulled into -mm (?) and get some exposure...
> 
> ok, we can certainly try it there.

Anything particular I have to do to get it into the x86 tree? And
presumably that tree is going to be picked up by Andrew at some
point? (-mm exposure is the main objective here, the only reason I
didn't send it to Andrew directly is in the interests of doing the
right thing).


> Your code is really nifty.

Thanks. One of the CPU engineers at Intel asked to use it as their reference
ticket lock code sequence, which was pretty cool :)
