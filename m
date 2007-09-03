Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbXICXp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbXICXp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 19:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbXICXpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 19:45:20 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34273 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbXICXpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 19:45:19 -0400
Date: Mon, 3 Sep 2007 19:43:51 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk,
       bharata@linux.vnet.ibm.com, j.blunck@tu-harburg.de,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 03/32] VFS/fsstack: cpp endif comments
Message-ID: <20070903234351.GB19168@filer.fsl.cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu> <11887860564146-git-send-email-jsipek@cs.sunysb.edu> <Pine.LNX.4.64.0709030838180.4454@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709030838180.4454@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 08:39:27AM +0200, Jan Engelhardt wrote:
> 
> On Sep 2 2007 22:20, Josef 'Jeff' Sipek wrote:
> >diff --git a/include/linux/fs_stack.h b/include/linux/fs_stack.h
> >index 6b52faf..28543ad 100644
> >--- a/include/linux/fs_stack.h
> >+++ b/include/linux/fs_stack.h
> >@@ -39,4 +39,4 @@ static inline void fsstack_copy_attr_times(struct inode *dest,
> > 	dest->i_ctime = src->i_ctime;
> > }
> > 
> >-#endif /* _LINUX_FS_STACK_H */
> >+#endif /* not _LINUX_FS_STACK_H */
> 
> I hardly think this changes a thing, and it even goes against
> the de-facto standard of a lot of other files.

Fair enough. I'm going to drop it.

Jeff.

-- 
My public GPG key can be found at
http://www.josefsipek.net/gpg/public-0xC7958FFE.txt
