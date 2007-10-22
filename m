Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbXJVTww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbXJVTww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbXJVTwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:52:45 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10763 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbXJVTwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:52:44 -0400
Date: Mon, 22 Oct 2007 21:52:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071022195238.GH16425@kernel.dk>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <Pine.LNX.4.64.0710222137520.7105@anakin> <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22 2007, Linus Torvalds wrote:
> 
> 
> On Mon, 22 Oct 2007, Geert Uytterhoeven wrote:
> >
> > Better safe than sorry...
> > 
> > Is it possible that a chain entry pointer has bit 1 set on architectures
> > (e.g. m68k) where the natural alignment of 32-bit quantities is _2_ bytes,
> > not 4?
> 
> Better make sure that such alignment never happens... But no, I don't 
> think it will, since these things would generally always have to be 
> allocated with an allocator, and the *allocator* won't return 2-byte 
> aligned data structures.

How about stack allocations?

-- 
Jens Axboe

