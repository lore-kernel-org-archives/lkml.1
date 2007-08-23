Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbXHWDti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbXHWDti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbXHWDta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:49:30 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49929 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329AbXHWDt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:49:29 -0400
Date: Wed, 22 Aug 2007 20:47:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Subject: Re: fs/xfs/xfs_bmap_btree.c - compile error  (Re: 2.6.23-rc3-mm1)
Message-Id: <20070822204736.adaf9fc6.randy.dunlap@oracle.com>
In-Reply-To: <46CCC811.6050601@googlemail.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<46CCC811.6050601@googlemail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 01:34:41 +0200 Gabriel C wrote:

> 
> config : http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/r/randconfig-18
> 
> ...
> 
> fs/xfs/xfs_bmap_btree.c: In function 'xfs_bmbt_set_allf':
> fs/xfs/xfs_bmap_btree.c:2312: error: 'b' undeclared (first use in this function)
> fs/xfs/xfs_bmap_btree.c:2312: error: (Each undeclared identifier is reported only once
> fs/xfs/xfs_bmap_btree.c:2312: error: for each function it appears in.)
> fs/xfs/xfs_bmap_btree.c: In function 'xfs_bmbt_disk_set_allf':
> fs/xfs/xfs_bmap_btree.c:2372: error: 'b' undeclared (first use in this function)
> make[2]: *** [fs/xfs/xfs_bmap_btree.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
>   CC      fs/reiser4/safe_link.o
>   CC      fs/reiser4/plugin/plugin.o
> make[1]: *** [fs/xfs] Error 2
> make[1]: *** Waiting for unfinished jobs....


patch is here:  
http://lkml.org/lkml/2007/8/22/153

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
