Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZD0N1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZD0N1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 09:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZD0N1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 09:27:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZD0N1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 09:27:41 -0400
Date: Mon, 27 Apr 2009 15:27:38 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [PATCH 0/4] Fix sys_sync() and cleanup code (version 3)
Message-ID: <20090427132738.GC7194@duck.suse.cz>
References: <1240522536-2994-1-git-send-email-jack@suse.cz> <20090426115410.GA4725@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090426115410.GA4725@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 26-04-09 07:54:10, Christoph Hellwig wrote:
> Any chance you could move sync_filesystems to fs/sync.c?  It fits in
> there much better.  Same is probably true for (__)fsync_super, which
> could also use a better name..
  OK, I've moved the syncing code to sync.c and renamed fsync_super() to
sync_filesystem() which better describes what it does I think.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
