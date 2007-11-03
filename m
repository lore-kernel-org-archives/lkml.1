Return-Path: <linux-kernel-owner+w=401wt.eu-S1761576AbXKCA5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576AbXKCA5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbXKCA47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:56:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426AbXKCA47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:56:59 -0400
Message-ID: <472BC74E.9090505@redhat.com>
Date: Fri, 02 Nov 2007 20:56:46 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de> <472B4ECE.7010602@redhat.com> <alpine.LFD.0.999.0711020950250.3342@woody.linux-foundation.org> <20071102230142.GC26562@wotan.suse.de>
In-Reply-To: <20071102230142.GC26562@wotan.suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2007 07:01 PM, Nick Piggin wrote:
> 
> In the contended multi-threaded tight loop, the xchg lock is slower than inc
> lock but still beats the fair xadd lock, but that's only because it is
> just as unfair if not more so on this hardware (runtime difference of up to
> about 10%)
> 

I meant xchg for unlock, not lock.

