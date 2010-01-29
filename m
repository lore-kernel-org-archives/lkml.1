Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837Ab0A2WX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab0A2WX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771Ab0A2WX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:23:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab0A2WX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:23:57 -0500
Date: Fri, 29 Jan 2010 17:23:55 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 03/10] hpfsplus: Convert tree_lock to mutex
Message-ID: <20100129222355.GC16158@infradead.org>
References: <20100129203549.526478432@linutronix.de> <20100129203613.480321949@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129203613.480321949@linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 08:38:42PM -0000, Thomas Gleixner wrote:
> The tree_lock semaphore is used as mutex. Convert it to a real mutex.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> 
> ---
>  fs/hfsplus/bfind.c      |    4 ++--
>  fs/hfsplus/btree.c      |    2 +-
>  fs/hfsplus/hfsplus_fs.h |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

