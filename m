Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbYJZQlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbYJZQlc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 12:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYJZQlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 12:41:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYJZQlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 12:41:22 -0400
Date: Sun, 26 Oct 2008 12:41:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Rename DECLARE_MUTEX to DEFINE_SEMAPHORE
Message-ID: <20081026164118.GA19812@infradead.org>
References: <20081026120609.GA10728@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081026120609.GA10728@joi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 01:06:14PM +0100, Marcin Slusarz wrote:
> DECLARE_MUTEX is doubly misleading name (it actually _defines_ struct
> _semaphore_ initialized to 1) and it can be confused with DEFINE_MUTEX
> (which defines real struct mutex). Rename it.

NACK.  It describes reasonably well what it does.  Of course that's a
little confusing as we now have a specialized primitive to just do that.

If the name annoys you enough so that you want to get rid of it help
converting the remaining instances to struct mutex and DEFINE_MUTEX().

