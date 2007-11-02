Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbXKBQw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbXKBQw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 12:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbXKBQwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 12:52:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbXKBQwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 12:52:20 -0400
Date: Fri, 2 Nov 2007 09:51:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
In-Reply-To: <472B4ECE.7010602@redhat.com>
Message-ID: <alpine.LFD.0.999.0711020950250.3342@woody.linux-foundation.org>
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de>
 <472B4ECE.7010602@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Nov 2007, Chuck Ebbert wrote:
> 
> There's also a very easy way to get better fairness with our current spinlocks:
> use xchg to release the lock instead of mov.

That does nothing at all.

Yes, it slows the unlock down, which in turn on some machines will make it 
easier for another core/socket to get it, but it's purely about the 
slowdown, nothing else. 

			Linus
