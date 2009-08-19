Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZHSQ0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZHSQ0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZHSQ0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:26:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38840 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbZHSQ0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:26:38 -0400
Date: Wed, 19 Aug 2009 12:26:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
       Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>, Felix Blyakher <felixb@sgi.com>,
       xfs@oss.sgi.com, Anton Altaparmakov <aia21@cantab.net>,
       linux-ntfs-dev@lists.sourceforge.net,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-ext4@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Message-ID: <20090819162638.GE6150@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-8-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250697884-22288-8-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.  Eventually we should use those SYNC_ flags also all
through the fsync codepath, but I'll see if I can incorporate that in my
planned fsync rewrite.
