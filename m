Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbZG0P0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbZG0P0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbZG0PZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:25:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34144 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbZG0PZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:25:59 -0400
Date: Mon, 27 Jul 2009 11:25:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [Patch RFC 24/37] xfs: semaphore cleanup
Message-ID: <20090727152558.GC31597@infradead.org>
References: <20090726081459.455111897@linutronix.de> <20090726081556.395690256@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090726081556.395690256@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 08:19:03AM -0000, Thomas Gleixner wrote:
> bp->b_sema claims to be a mutex, but it is a semaphore with non
> obvious semantics. Make it a real semaphore.

It is a binary mutex in the classical CS sense, just not unlocked by
the same thread as expected by the Linux mutexes..

