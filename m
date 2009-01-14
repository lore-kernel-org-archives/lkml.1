Return-Path: <linux-kernel-owner+w=401wt.eu-S1765295AbZANRke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765295AbZANRke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbZANRkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:40:25 -0500
Received: from styx.suse.cz ([82.119.242.94]:46749 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756759AbZANRkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:40:24 -0500
Date: Wed, 14 Jan 2009 18:40:23 +0100
From: Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, pavel@suse.cz
Subject: Re: [PATCH 2/2] ext2: Add blk_issue_flush() to syncing paths
Message-ID: <20090114174023.GK19950@duck.suse.cz>
References: <1231945948-23676-1-git-send-email-jack@suse.cz> <1231945948-23676-2-git-send-email-jack@suse.cz> <496E2276.8050309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496E2276.8050309@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-01-09 11:35:50, Eric Sandeen wrote:
> Jan Kara wrote:
> > To be really safe that the data hit the platter, we should also flush drive's
> > writeback caches on fsync and for O_SYNC files or O_DIRSYNC inodes.
> 
> Seems sane, but aren't we getting really divergent behavior here between
> ext2, ext3, and ext4 w.r.t. drive cache flushing for sync paths?
  Well, but ext3/4 should do a barrier on a transaction commit (if the user
really cares about data integrity) and hence it implicitely does the same.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
