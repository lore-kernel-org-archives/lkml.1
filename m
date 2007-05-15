Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbXEOQBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbXEOQBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 12:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757568AbXEOQBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 12:01:01 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757352AbXEOQBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 12:01:00 -0400
Date: Tue, 15 May 2007 09:00:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: nate.diller@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Timothy Shimmin <tes@sgi.com>, Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Re: [PATCH] deprecate memclear_highpage_flush deprecation warnings
Message-Id: <20070515090032.e6f94d58.akpm@linux-foundation.org>
In-Reply-To: <20070515122440.GA8765@lst.de>
References: <20070515122440.GA8765@lst.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 14:24:40 +0200 Christoph Hellwig <hch@lst.de> wrote:

> Recent builds get tons of warnings about memclear_highpage_flush
> beeing deprecated.  Turns out it's replaced by zero_user_page
> which takes an additional argument.
> 
> Now folks, deprecated is for actual functionality going away, there
> is no need to mark the old name deprecated for such a trivial
> paramter change and rename.

Yes, it's rather trivial, but memclear_highpage_flush() *is* going away.

>  This stuff should go to Linus in one
> patch that doesn't create utterly useless warnings and keeps around
> stale interfaces.
> 
> Here's a patch to kill memclear_highpage_flush and convert the reaming
> user to make the build a littler more silent, it's more than noisy
> enough due to all the useless addition of __deprecated or __must_check
> to widely used functionality and gcc stupid false positives.

Patches have been prepared which convert all in-kernel users.  I thought
I'd dtrt and feed them through maintainers, but that takes time.  The
laggards are on cc ;)
