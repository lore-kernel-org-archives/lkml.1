Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbZJKJGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbZJKJGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696AbZJKJGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:06:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:57159 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104AbZJKJGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:06:52 -0400
Subject: Re: [patch 22/28] macintosh: Remove BKL from ans-lcd
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20091010153349.966159859@linutronix.de>
References: <20091010153314.827301943@linutronix.de>
	 <20091010153349.966159859@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Oct 2009 20:02:02 +1100
Message-Id: <1255251722.2192.33.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 15:37 +0000, Thomas Gleixner wrote:
> plain text document attachment (drivers-mac-ans-lcd-remove-bkl.patch)
> The ans-lcd driver got the cycle_kernel_lock() in anslcd_open() from
> the BKL pushdown and it still uses the locked ioctl.
> 
> The BKL serialization in this driver is more than obscure and
> definitely does not cover all possible corner cases. Protect the
> access to the hardware with a local mutex and get rid of BKL and
> locked ioctl.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: linuxppc-dev@ozlabs.org
> ---

While I -do- have an ANS ... it's rusting in the back of my garage and I
really don't have time nor space to set it up and get it back to booting
shape :-) (It's a pretty huge thing)

Patch looks good, so if it builds...

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.

