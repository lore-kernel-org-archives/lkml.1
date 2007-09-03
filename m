Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbXICGjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbXICGjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 02:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbXICGj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 02:39:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46168 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXICGj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 02:39:28 -0400
Date: Mon, 3 Sep 2007 08:39:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk,
       bharata@linux.vnet.ibm.com, j.blunck@tu-harburg.de,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 03/32] VFS/fsstack: cpp endif comments
In-Reply-To: <11887860564146-git-send-email-jsipek@cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0709030838180.4454@fbirervta.pbzchgretzou.qr>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
 <11887860564146-git-send-email-jsipek@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 2 2007 22:20, Josef 'Jeff' Sipek wrote:
>diff --git a/include/linux/fs_stack.h b/include/linux/fs_stack.h
>index 6b52faf..28543ad 100644
>--- a/include/linux/fs_stack.h
>+++ b/include/linux/fs_stack.h
>@@ -39,4 +39,4 @@ static inline void fsstack_copy_attr_times(struct inode *dest,
> 	dest->i_ctime = src->i_ctime;
> }
> 
>-#endif /* _LINUX_FS_STACK_H */
>+#endif /* not _LINUX_FS_STACK_H */

I hardly think this changes a thing, and it even goes against
the de-facto standard of a lot of other files.


	Jan
-- 
