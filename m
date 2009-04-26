Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZDZLyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZDZLyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZDZLyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:54:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48756 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZDZLyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:54:13 -0400
Date: Sun, 26 Apr 2009 07:54:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [PATCH 0/4] Fix sys_sync() and cleanup code (version 3)
Message-ID: <20090426115410.GA4725@infradead.org>
References: <1240522536-2994-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240522536-2994-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any chance you could move sync_filesystems to fs/sync.c?  It fits in
there much better.  Same is probably true for (__)fsync_super, which
could also use a better name..
