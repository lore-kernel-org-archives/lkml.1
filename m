Return-Path: <linux-kernel-owner+w=401wt.eu-S1763660AbZE0OXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763660AbZE0OXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761983AbZE0OXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:23:42 -0400
Received: from THUNK.ORG ([69.25.196.29]:56886 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761539AbZE0OXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:23:41 -0400
Date: Wed, 27 May 2009 10:23:32 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/11] Fix page_mkwrite() for blocksize < pagesize
Message-ID: <20090527142332.GB10842@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
	linux-ext4@vger.kernel.org
References: <1243429268-3028-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243429268-3028-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 03:00:57PM +0200, Jan Kara wrote:
> 
> The series is against 2.6.30-rc7. The first two patches are just
> small cleanup and should be merged separately (Ted should have the
> ext4 cleanup rebased on top of current ext4 tree). 

So I can take the cleanup (which will be different given the changes
that are ready to get merged once the merge window opens), but it
looks like the the second ext4 patch can't go in until we get
agreement that changes to the VFS layer should go in, correct?  So
we'll have a merge order dependency here.

(And this one will be the 2nd merge order dependency we have in the
ext4 tree, since I also have some patches in the unstable portion of
the tree which are waiting for some tracing patches to go in.)

OK, what I'll probably do is to merge the core VFS patch plus the 2nd
ext4 patch into the ext4 patch queue in the unstable portion of the
queue for testing purposes, but I won't actually push the VFS core
changes.  We can figure out later who actually pushes the ext4 patch
which utilizes the new VFS infrastructure.

						- Ted
