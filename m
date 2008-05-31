Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbYEaI3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbYEaI3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 04:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYEaI3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 04:29:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46928 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYEaI3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 04:29:35 -0400
Date: Sat, 31 May 2008 04:29:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] vfs: create file_remove_suid() helper
Message-ID: <20080531082934.GG24135@infradead.org>
References: <20080529113245.450308367@szeredi.hu> <20080529113318.257547449@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529113318.257547449@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 01:32:53PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> All calls to remove_suid() are made with a file pointer.  This is not
> accidental: similarly to file_update_time(), this function is called
> when the file is written.
> 
> So simplify callers by passing the file pointer instead of the dentry.

It's not simplifying anything at all.  You just move the pointer
derefence down one step the callchain without any need.

