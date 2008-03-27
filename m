Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbYC0M01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbYC0M01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758449AbYC0MYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:24:23 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33815 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183AbYC0MYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:24:13 -0400
Message-Id: <20080327120619.031944658@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 27 Mar 2008 13:06:19 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/7] vfs: mountinfo (v4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another update that fixes Al's latest comments:

 - the per-sb options are merged into the fs-specific options
 - mount source is shown as a separate field (because commas are not
   escaped within it)
 - group id checking before allocation/freeing: this one doesn't
   actually make a difference for the moment (I hope) but Al's variant
   is cleaner
 - simplify ID allocation and freeing
 - dominator renaming
 - function header comment updating

Updated the git tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git mountinfo

I suspect it doesn't work for -mm, because it's not based on -linus
directly, but on the mountinfo-base branch in the vfs-2.6.git tree.

Andrew, I'm happy that you applied the patches, but if it's the
slightest inconvenience to deal with them, just leave it.  It'll get
there through the vfs-2.6 tree anyway.

Thanks,
Miklos

--
