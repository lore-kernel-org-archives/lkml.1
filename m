Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbYFYATQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbYFYATQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 20:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbYFYASs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 20:18:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10634 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbYFYASr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 20:18:47 -0400
Date: Tue, 24 Jun 2008 17:18:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       xfs-masters@oss.sgi.com
Subject: Re: linux-next: Tree for June 24 (XFS x2)
Message-Id: <20080624171809.42bbdf68.randy.dunlap@oracle.com>
In-Reply-To: <20080624175612.cdf29651.sfr@canb.auug.org.au>
References: <20080624175612.cdf29651.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XFS shows 2 build problems today.

1. xfs_stats.h problem

  CC      fs/xfs/xfs_rtalloc.o
In file included from /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_linux.h:91,
                 from /local/linsrc/linux-next-20080624/fs/xfs/xfs.h:44,
                 from /local/linsrc/linux-next-20080624/fs/xfs/xfs_rtalloc.c:18:
/local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_stats.h: In function 'xfs_init_procfs':
/local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_stats.h:150: error: expected ';' before '}' token
make[3]: *** [fs/xfs/xfs_rtalloc.o] Error 1

2. ACL's undefined

  CC      fs/xfs/linux-2.6/xfs_xattr.o
/local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c: In function 'xfs_decode_acl':
/local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c:40: error: '_ACL_TYPE_ACCESS' undeclared (first use in this function)
/local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c:40: error: (Each undeclared identifier is reported only once
/local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c:40: error: for each function it appears in.)
/local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c:42: error: '_ACL_TYPE_DEFAULT' undeclared (first use in this function)
make[3]: *** [fs/xfs/linux-2.6/xfs_xattr.o] Error 1



These happened multiple times.  .configs are available if needed.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
