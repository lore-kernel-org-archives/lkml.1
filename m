Return-Path: <linux-kernel-owner+w=401wt.eu-S1762852AbYEUIFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762852AbYEUIFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758464AbYEUIFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:05:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43600 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562AbYEUIFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:05:04 -0400
Date: Wed, 21 May 2008 04:04:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Introduce down_nowait()
Message-ID: <20080521080452.GA1305@infradead.org>
References: <200805211600.16415.rusty@rustcorp.com.au> <20080520232903.6756b1c1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520232903.6756b1c1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 11:29:03PM -0700, Andrew Morton wrote:
> Actually, I don't thing down_nowait() is a terribly good name, because it
> doesn't tell the reader anything about what to expect from the return
> value.  Does a non-zero return mean that down_wait() acquired the lock,
> or does it not?  Something like down_try() would be better, because if
> it returns 1 we can say "ah, the trying succeeded".

Actually, it does, and the kerneldoc comment explains it in every detail
for those who need to read it up.  Then again semaphores and on their
way out, and I really hate the kind of churn this thing introduces at
this moment.  Please let all the semaphore to completion/mutex/other
construct change settle for a while, and with a little chance this gem
will just go away entirely.

