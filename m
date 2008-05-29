Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbYE2Nuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbYE2Nuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYE2Nub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:50:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46079 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYE2Nua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:50:30 -0400
Message-Id: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:03 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 00/15] security: pass path instead of inode to security ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is in preparation for the AppArmor merge.  It's rather
boring, except perhaps the last two patches, which deal with
permission().

VFS API is touched very little, since the path has already been passed
down by callers.

This is based on the vfs-cleanups(*) tree + the 8 patches posted
recently (which will be added to this tree shortly).  If no problems
are found I'll create a new "apparmor" branch on that tree and commit
these patches there.

Thanks,
Miklos

(*) git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git vfs-cleanups

--
