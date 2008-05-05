Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbYEELNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbYEELNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYEELNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:13:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55475 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbYEELNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:13:02 -0400
Date: Mon, 5 May 2008 07:12:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 11/15] vfs: truncate: append-only checking cleanup
Message-ID: <20080505111259.GH20910@infradead.org>
References: <20080505095440.820370974@szeredi.hu> <20080505095524.893316989@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505095524.893316989@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 11:54:52AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Move the append-only checks from truncate to notify_change().  Checks
> for append-only files are always performed by the VFS and not by the
> filesystem so this belongs in notify_change(), and not in
> inode_change_ok().

Looks good to me.
