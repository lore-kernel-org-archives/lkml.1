Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbZG0PZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbZG0PZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZG0PZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:25:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34125 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZG0PZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:25:06 -0400
Date: Mon, 27 Jul 2009 11:25:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Patch RFC 01/37] semaphore: Add DEFINE_SEMAPHORE,
	semaphore_init, semaphore_init_locked
Message-ID: <20090727152505.GB31597@infradead.org>
References: <20090726081459.455111897@linutronix.de> <20090726081553.328151390@linutronix.de> <1248649489.28841.11.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248649489.28841.11.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 04:04:49PM -0700, Daniel Walker wrote:
> Maybe you could introduce this _after_ you do the semaphore to
> completion cleanup .. This init_locked is just adding a bunch of code
> flux on top of that..

I agree.  For these 36 patches we should first check if they can
be trivially converted to mutexes or completions and only change them
away to the semaphore named initializers.

