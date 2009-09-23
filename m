Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbZIWUra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbZIWUra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 16:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZIWUr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 16:47:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:34934 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZIWUr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 16:47:28 -0400
Date: Thu, 24 Sep 2009 06:46:32 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT] bugfixes for the security subsystem
Message-ID: <alpine.LRH.2.00.0909240643380.5253@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these fixes.

The following changes since commit 43c1266ce4dc06bfd236cec31e11e9ecd69c0bef:
  Linus Torvalds (1):
        Merge branch 'perfcounters-rename-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Andrew Morton (1):
      include/linux/cred.h: fix build

David Howells (1):
      KEYS: Have the garbage collector set its timer for live expired keys

Eric Paris (1):
      SELinux: do not destroy the avc_cache_nodep

Jason Gunthorpe (1):
      tpm-fixup-pcrs-sysfs-file-update

Randy Dunlap (1):
      creds_are_invalid() needs to be exported for use by modules:

 drivers/char/tpm/tpm.c |    5 ++---
 include/linux/cred.h   |   18 +-----------------
 kernel/cred.c          |   19 +++++++++++++++++++
 security/keys/gc.c     |    4 ++--
 security/selinux/avc.c |   19 +++++++++++++++----
 5 files changed, 39 insertions(+), 26 deletions(-)


-- 
James Morris
<jmorris@namei.org>
