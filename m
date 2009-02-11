Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbZBKRNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbZBKRNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbZBKRN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:13:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbZBKRN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:13:27 -0500
Date: Wed, 11 Feb 2009 18:13:24 +0100
From: Jan Kara <jack@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: mmotm 2009-02-10-16-35 uploaded (reiser4-quota)
Message-ID: <20090211171324.GC13817@duck.suse.cz>
References: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org> <499305AD.4020900@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499305AD.4020900@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-02-09 09:06:53, Randy Dunlap wrote:
> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-02-10-16-35 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> 
> 
> mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:456: error: implicit declaration of function 'DQUOT_TRANSFER'
> mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:596: error: implicit declaration of function 'DQUOT_ALLOC_INODE'
> mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:597: error: implicit declaration of function 'DQUOT_DROP'
> mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:611: error: implicit declaration of function 'DQUOT_FREE_INODE'
  Ah, out of tree filesystems... Could some of Reiser4 guys convert the
quota names (they should be vfs_dq_transfer, vfs_dq_alloc_inode,
vfs_dq_drop, vfs_dq_free_inode)? I suppose I could do it myself but I'm not
sure if it won't clash with some other changes.
  Thanks for report Randy.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
