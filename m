Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbZEJUJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbZEJUJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 16:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbZEJUIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 16:08:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbZEJUIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 16:08:50 -0400
Message-Id: <20090510200535.893737918@suse.com>
User-Agent: quilt/0.47-14.9
Date: Sun, 10 May 2009 16:05:35 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de
Subject: [patch 0/4] reiserfs xattr fixups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Here are my remaining patches for reiserfs in 2.6.30:

 - reiserfs-xattr-fixup: Cleans up some ifdefs
 - reiserfs-xattr-root-fixup: Fixes an oops on open_xa_dir with
			      CONFIG_REISERFS_FS_XATTR=n
 - reiserfs-xattrs-disabled-perms: Fixes warnings on delete with
			      CONFIG_REISERFS_FS_XATTR=n (bko#13122)
 - reiserfs-expose-privroot: Adds a -oexpose_privroot that will allow
			     access to the privroot.

 Please apply.

 -Jeff

--
Jeff Mahoney
SUSE Labs



