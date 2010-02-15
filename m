Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0BOQP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:15:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0BOQP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:15:28 -0500
Date: Mon, 15 Feb 2010 11:15:23 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Add flags to __d_path for suppressing suffix and
	mapping /proc/self
Message-ID: <20100215161523.GA31908@infradead.org>
References: <201002152311.IGC00525.SFOVtLJQFMOHFO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002152311.IGC00525.SFOVtLJQFMOHFO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 11:11:37PM +0900, Tetsuo Handa wrote:
> This patch allows __d_path() to
> (1) suppress " (deleted)" suffix if dentry was already deleted

This part looks fine to me.

> (2) convert /proc/PID to /proc/self if dentry is under /proc/self directory

This not.  If you security module is broken enough to require special
casing /proc/pid entries that's your business, but there's not reason
to put ugly hacks into core code for that.

