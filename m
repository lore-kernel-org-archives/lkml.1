Return-Path: <linux-kernel-owner+w=401wt.eu-S1765709AbXJRTcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765709AbXJRTcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbXJRTcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:32:42 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22514 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942AbXJRTcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:32:41 -0400
Date: Thu, 18 Oct 2007 21:32:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, Mark Lord <lkml@rtr.ca>
Subject: Re: libata crash
Message-ID: <20071018193236.GJ10674@kernel.dk>
References: <20071018164745.GD10674@kernel.dk> <20071018192839.GA17247@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018192839.GA17247@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Hi Ingo,
> > 
> > Can you try this rolled up patch against current -git and see if it 
> > works for you?
> 
> update: booted up a couple of times with your patch (with 
> DEBUG_PAGEALLOC enabled) and it's working all fine, no crashes. So i 
> think you nailed it!

Awesome, thanks a lot for testing it Ingo!

I'll see if I can spend some time tonight chopping the patch into
digestable pieces, unfortunately I'll be away the next three days. And
it would be nice to get this thing merged asap.

-- 
Jens Axboe

