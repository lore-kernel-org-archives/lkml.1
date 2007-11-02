Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbXKBBUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbXKBBUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbXKBBUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:20:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59127 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522AbXKBBUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:20:36 -0400
Date: Thu, 1 Nov 2007 18:19:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: Gregory Haskins <gregory.haskins.ml@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
In-Reply-To: <20071101203526.293cd7f0@bree.surriel.com>
Message-ID: <alpine.LFD.0.999.0711011819110.3342@woody.linux-foundation.org>
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de>
 <4729E567.1050402@gmail.com> <alpine.LFD.0.999.0711010935060.3342@woody.linux-foundation.org>
 <20071101203526.293cd7f0@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Nov 2007, Rik van Riel wrote:
> 
> Larry Woodman managed to wedge the VM into a state where, on his
> 4x dual core system, only 2 cores (on the same CPU) could get the
> zone->lru_lock overnight.  The other 6 cores on the system were
> just spinning, without being able to get the lock.

.. and this is almost always the result of a locking *bug*, not unfairness 
per se. IOW, unfairness just ends up showing the bug in the first place.

		Linus
