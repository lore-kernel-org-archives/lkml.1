Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbYEGPkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbYEGPkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763286AbYEGPjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:39:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763225AbYEGPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:39:17 -0400
Date: Wed, 7 May 2008 08:38:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH take 2 01/28] VFS: introduce writeback_inodes_sb()
Message-Id: <20080507083835.6ba126e6.akpm@linux-foundation.org>
In-Reply-To: <48218F21.4090304@yandex.ru>
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>
	<1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com>
	<20080507002345.831bc379.akpm@linux-foundation.org>
	<48218F21.4090304@yandex.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 14:14:41 +0300 Artem Bityutskiy <dedekind@yandex.ru> wrote:

> Hi Andrew,
> 
> Andrew Morton wrote:
> > This looks rather similar to
> > http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-sb_sync_inodes.patch
> > 
> > Which is best?
> 
> Well, this reiser4 patch is basically doing 3 things at once:
> 1. Introduce ->sync_inodes()
> 2. Move spin_lock(&inode_lock);
> 3. Export generic_sync_sb_inodes()
> 
> As Christoph suggested, I've attached a patch which just moves the
> spinlock. Could you please consider sending it to Linus or taking into your tree?

I already added gti-ubifs.patch to the -mm lineup.  I haven't yet tried
pulling, merging or compiling it.

I'd suggest that you just retain this patch in your tree.

> Should I amend the reiser4 patch correspondingly for you?

That would be nice, if you have time, thanks.

> Also, what do you think about taking UBIFS into your tree?

I take git trees pretty promiscuously, to get them a bit more exposure and
merge/build testing.

