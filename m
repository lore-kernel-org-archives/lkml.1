Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbZAVKiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbZAVKiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 05:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZAVKht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 05:37:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:14101 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZAVKhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 05:37:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OhrqL1F6ZXcEoaOGPFoOJoUwpCfZAvYn02qyNODh5lKlXSJcgDsUp7iQaGKDbQdE/k
         5glB5n7rqe1mkWusuR6GM9G4hlINDz0zl5exwd+DRUV/gLX3lJzgJqfdVhGg3hS6Xsa7
         S8j8sOh249Vom7L8sVEl5ZDK5FAPYFrEBCPyU=
Date: Thu, 22 Jan 2009 13:43:16 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] Finish fs/Kconfig split
Message-ID: <20090122104316.GA3631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/misc.git Kconfig

to get finalization of fs/Kconfig split into individual fs/*/Kconfig files.
FS maintainers liked the idea overall and patches for ext* et al are already in.

I can sit here and carefully minimize reject pain for everyone or you can do
the right thing.

Alexey Dobriyan (36):
      fs/Kconfig: move reiserfs out
      fs/Kconfig: move jfs out
      fs/Kconfig: move ocfs2 out
      fs/Kconfig: move btrfs out
      fs/Kconfig: move autofs, autofs4 out
      fs/Kconfig: move fuse out
      fs/Kconfig: move iso9660, udf out
      fs/Kconfig: move fat out
      fs/Kconfig: move ntfs out
      fs/Kconfig: move sysfs out
      fs/Kconfig: move configfs out
      fs/Kconfig: move adfs out
      fs/Kconfig: move affs out
      fs/Kconfig: move ecryptfs out
      fs/Kconfig: move hfs, hfsplus out
      fs/Kconfig: move befs out
      fs/Kconfig: move bfs out
      fs/Kconfig: move efs out
      fs/Kconfig: move cramfs out
      fs/Kconfig: move squashfs out
      fs/Kconfig: move vxfs out
      fs/Kconfig: move minix out
      fs/Kconfig: move omfs out
      fs/Kconfig: move hpfs out
      fs/Kconfig: move qnx4 out
      fs/Kconfig: move romfs out
      fs/Kconfig: move sysv out
      fs/Kconfig: move ufs out
      fs/Kconfig: move nfs out
      fs/Kconfig: move nfsd out
      fs/Kconfig: move sunrpc out
      fs/Kconfig: move smbfs out
      fs/Kconfig: move the rest of ncpfs out
      fs/Kconfig: move coda out
      fs/Kconfig: move afs out
      fs/Kconfig: move 9p out

 fs/9p/Kconfig       |   10 
 fs/Kconfig          | 1401 +---------------------------------------------------
 fs/adfs/Kconfig     |   27 +
 fs/affs/Kconfig     |   21 
 fs/afs/Kconfig      |   21 
 fs/autofs/Kconfig   |   21 
 fs/autofs4/Kconfig  |   20 
 fs/befs/Kconfig     |   26 
 fs/bfs/Kconfig      |   19 
 fs/btrfs/Kconfig    |   18 
 fs/coda/Kconfig     |   21 
 fs/configfs/Kconfig |   11 
 fs/cramfs/Kconfig   |   19 
 fs/ecryptfs/Kconfig |   11 
 fs/efs/Kconfig      |   14 
 fs/fat/Kconfig      |   97 +++
 fs/freevxfs/Kconfig |   16 
 fs/fuse/Kconfig     |   15 
 fs/hfs/Kconfig      |   12 
 fs/hfsplus/Kconfig  |   13 
 fs/hpfs/Kconfig     |   14 
 fs/isofs/Kconfig    |   39 +
 fs/jfs/Kconfig      |   49 +
 fs/minix/Kconfig    |   17 
 fs/ncpfs/Kconfig    |   21 
 fs/nfs/Kconfig      |   86 +++
 fs/nfsd/Kconfig     |   80 ++
 fs/ntfs/Kconfig     |   78 ++
 fs/ocfs2/Kconfig    |   85 +++
 fs/omfs/Kconfig     |   13 
 fs/qnx4/Kconfig     |   25 
 fs/reiserfs/Kconfig |   85 +++
 fs/romfs/Kconfig    |   16 
 fs/smbfs/Kconfig    |   55 ++
 fs/squashfs/Kconfig |   51 +
 fs/sysfs/Kconfig    |   23 
 fs/sysv/Kconfig     |   36 +
 fs/udf/Kconfig      |   18 
 fs/ufs/Kconfig      |   43 +
 net/sunrpc/Kconfig  |   79 ++
 40 files changed, 1363 insertions(+), 1363 deletions(-)
