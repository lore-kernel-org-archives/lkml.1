Return-Path: <linux-kernel-owner+w=401wt.eu-S1759633AbYFJWIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633AbYFJWIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbYFJWIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:08:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:54627 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbYFJWII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TUiGMsAp5ycUjWtoYPWxpV4QEuEBAfSwh/zSkIC/pH3cRiZCPIxcaRi91IA649Rp+B
         wCA03BzOTg9FJfzaKC1OeFIQuCGIvXeBOpmL2cjOzE9AjN0MbI71yahKzzZwXYs/jyzl
         o5os/RcT3Jb7oliPX/H30Gj3tEtx+YeiOX6do=
Message-ID: <524f69650806101508q130fae6aqa4dc933b5d5a7c28@mail.gmail.com>
Date: Tue, 10 Jun 2008 17:08:05 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [GIT] CIFS Fixes
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeff Layton" <jlayton@redhat.com>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cbff290491cd97bcd449b14f672d98992ddad5cb:
  Linus Torvalds (1):
        Merge branch 'merge' of git://git.kernel.org/.../paulus/powerpc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (4):
      on non-posix shares, clear write bits in mode when ATTR_READONLY is set
      when creating new inodes, use file_mode/dir_mode exclusively on
mount without unix extensions
      silently ignore ownership changes unless unix extensions are
enabled or we're faking uid changes
      disable most mode changes on non-unix/non-cifsacl mounts

Steve French (6):
      [CIFS] remove unused variables
      [CIFS] remove trailing whitespace
      [CIFS] warn if both dynperm and cifsacl mount options specified
      [CIFS] Correct incorrect obscure open flag
      [CIFS] Fix hang in mount when negprot causes server to kill tcp session
      [CIFS] cifs: fix oops on mount when CONFIG_CIFS_DFS_UPCALL is enabled

 fs/cifs/CHANGES    |    5 ++
 fs/cifs/cifsfs.c   |   21 ++++----
 fs/cifs/cifsglob.h |    3 +-
 fs/cifs/cifspdu.h  |   23 ++++++--
 fs/cifs/cifssmb.c  |    6 +--
 fs/cifs/connect.c  |    5 ++
 fs/cifs/dir.c      |    4 +-
 fs/cifs/file.c     |    7 ---
 fs/cifs/inode.c    |  148 ++++++++++++++++++++++++++++++---------------------
 fs/cifs/misc.c     |    3 +-
 fs/cifs/readdir.c  |   77 ++++++++++++++-------------
 11 files changed, 172 insertions(+), 130 deletions(-)


-- 
Thanks,

Steve
