Return-Path: <linux-kernel-owner+w=401wt.eu-S1757778AbZC3S5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbZC3S5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZC3S5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:57:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753246AbZC3S5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:57:12 -0400
Date: Mon, 30 Mar 2009 11:55:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: fs: move bdev code out of buffer.c
Message-Id: <20090330115524.e78dbe14.akpm@linux-foundation.org>
In-Reply-To: <200903280059.n2S0xvhK006987@hera.kernel.org>
References: <200903280059.n2S0xvhK006987@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Mar 2009 00:59:57 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/linus/585d3bc06f4ca57f975a5a1f698f65a45ea66225
> Commit:     585d3bc06f4ca57f975a5a1f698f65a45ea66225
> Parent:     3ba13d179e8c24c68eac32b93593a6b10fcd1572
> Author:     Nick Piggin <npiggin@suse.de>
> AuthorDate: Wed Feb 25 10:44:19 2009 +0100
> Committer:  Al Viro <viro@zeniv.linux.org.uk>
> CommitDate: Fri Mar 27 14:44:03 2009 -0400
> 
>     fs: move bdev code out of buffer.c
>     
>     Move some block device related code out from buffer.c and put it in
>     block_dev.c. I'm trying to move non-buffer_head code out of buffer.c
>     
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

This patch moved the CONFIG_BLOCK=y declaration of freeze_bdev() out of
buffer_head.h and into fs.h.  But it left the CONFIG_BLOCK=n definition
of freeze_bdev() in buffer_head.h.

I'd have noticed this earlier had this patch been in linux-next.  But
despite having been apparently written over a month ago, it was never
(afaict) in linux-next.

This patch is missing Nick's Signed-off-by:.
