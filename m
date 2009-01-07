Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbZAGRWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbZAGRWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZAGRWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:22:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZAGRWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:22:44 -0500
Date: Wed, 7 Jan 2009 12:22:39 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
       snakebyte@gmx.de
Subject: Re: nfsd stuckage
Message-ID: <20090107172238.GA15127@infradead.org>
References: <20090106145612.d4d9948d.akpm@linux-foundation.org> <20090106230244.GB13785@fieldses.org> <20090106230356.GA31520@lst.de> <20090106230551.GC13785@fieldses.org> <20090107001501.GH13785@fieldses.org> <20090106162328.1b4511a6.akpm@linux-foundation.org> <20090107002816.GL13785@fieldses.org> <20090107074256.GA5102@infradead.org> <20090107165639.GA28489@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107165639.GA28489@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 11:56:39AM -0500, J. Bruce Fields wrote:
> OK.  Mind if we just revert the whole commit for now?  With the
> double-lock regression is still there for ecryptfs exports, then I'd
> rather do a simple revert of the whole patch and not try to pick out
> just the fs/nfsd/vfs.c part.

Umm, exporting ecryptfs would previously take the lower i_mutex in
the ecryptfs fsync method and now does in vfs_fsync, there should
be no changed in behaviour.

