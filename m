Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYK3U7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYK3U7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 15:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYK3U7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 15:59:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbYK3U7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 15:59:00 -0500
Date: Sun, 30 Nov 2008 12:58:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
cc: linux-kernel@vger.kernel.org, tibor.tajti@gmail.com
Subject: Re: [GIT PULL] UDF tree fixes
In-Reply-To: <20081127172313.GG32062@duck.suse.cz>
Message-ID: <alpine.LFD.2.00.0811301253370.24125@nehalem.linux-foundation.org>
References: <20081127172313.GG32062@duck.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Nov 2008, Jan Kara wrote:
> 
>   would you please pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus
> 
>   to get the following fix:
> Jan Kara (1):
>       udf: Fix BUG_ON() in destroy_inode()
> 
>   with diffstat:
> 
>  fs/buffer.c    |    1 +
>  fs/udf/inode.c |    1 +
>  2 files changed, 2 insertions(+)

Hmm. I really think you should use 'clear_inode()' rather than calling 
invalidate_inode_buffers() directly.

I pulled it, but I'm almost certain you did the wrong thing.

		Linus
