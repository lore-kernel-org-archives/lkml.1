Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbYEELCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbYEELCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759305AbYEELBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:01:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759298AbYEELBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:01:50 -0400
Date: Mon, 5 May 2008 07:01:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 09/15] vfs: immutable inode checking cleanup
Message-ID: <20080505110126.GD20910@infradead.org>
References: <20080505095440.820370974@szeredi.hu> <20080505095520.685137048@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505095520.685137048@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 11:54:50AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Move the immutable and append-only checks from chmod, chown and utimes
> into notify_change().  Checks for immutable and append-only files are
> always performed by the VFS and not by the filesystem (see
> permission() and may_...() in namei.c), so these belong in
> notify_change(), and not in inode_change_ok().

Looks fine to me.

