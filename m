Return-Path: <linux-kernel-owner+w=401wt.eu-S1761222AbXGPJYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761222AbXGPJYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbXGPJYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:24:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbXGPJYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:24:37 -0400
Date: Mon, 16 Jul 2007 11:24:35 +0200
From: Nick Piggin <npiggin@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch 2/2] x86_64: FIFO ticket spinlocks
Message-ID: <20070716092435.GB21464@wotan.suse.de>
References: <20070716045932.GA19914@wotan.suse.de> <20070716050134.GB19914@wotan.suse.de> <20070716101654.1c20493f@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716101654.1c20493f@the-village.bc.nu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 10:16:54AM +0100, Alan Cox wrote:
> > however the difference is quite small on Core2 and Opteron when working out of
> > cache, and becomes almost insignificant even on P4 when the lock misses cache.
> > trylock is more significantly slower, but they are relatively rare.
> 
> This has a 255 processor limit (worst case). That should probably be
> clearly documented for the future.

Yeah good point. I added an #error for it.
