Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZBLCth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZBLCth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZBLCt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:49:27 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55826 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZBLCt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:49:26 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jan Kara <jack@suse.cz>
Subject: Re: mmotm 2009-02-10-16-35 uploaded (reiser4-quota)
Cc: kosaki.motohiro@jp.fujitsu.com, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
In-Reply-To: <20090211171324.GC13817@duck.suse.cz>
References: <499305AD.4020900@oracle.com> <20090211171324.GC13817@duck.suse.cz>
Message-Id: <20090212114737.C8EA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 12 Feb 2009 11:49:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed 11-02-09 09:06:53, Randy Dunlap wrote:
> > akpm@linux-foundation.org wrote:
> > > The mm-of-the-moment snapshot 2009-02-10-16-35 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > and will soon be available at
> > > 
> > >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > 
> > mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:456: error: implicit declaration of function 'DQUOT_TRANSFER'
> > mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:596: error: implicit declaration of function 'DQUOT_ALLOC_INODE'
> > mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:597: error: implicit declaration of function 'DQUOT_DROP'
> > mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:611: error: implicit declaration of function 'DQUOT_FREE_INODE'
>   Ah, out of tree filesystems... Could some of Reiser4 guys convert the
> quota names (they should be vfs_dq_transfer, vfs_dq_alloc_inode,
> vfs_dq_drop, vfs_dq_free_inode)? I suppose I could do it myself but I'm not
> sure if it won't clash with some other changes.
>   Thanks for report Randy.
> 
> 									Honza

Andrew, recently I've never seen any reiser4 activity in LKML.
I would suggest to remove it from -mm.



