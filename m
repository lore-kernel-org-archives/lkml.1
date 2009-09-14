Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZINC7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZINC7F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 22:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbZINC7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 22:59:05 -0400
Received: from tundra.namei.org ([65.99.196.166]:39064 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbZINC7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 22:59:03 -0400
Date: Mon, 14 Sep 2009 12:58:34 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@elte.hu>,
       David Howells <dhowells@redhat.com>
Subject: [GIT] fix creds / SELinux regressions
In-Reply-To: <20090913025409.6583.58777.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0909141256530.29020@tundra.namei.org>
References: <20090913025409.6583.58777.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull.


The following changes since commit 86d710146fb9975f04c505ec78caa43d227c1018:
  Linus Torvalds (1):
        Merge git://git.linux-nfs.org/projects/trondmy/nfs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Eric Paris (3):
      Creds: creds->security can be NULL is selinux is disabled
      SELinux: seperate avc_cache flushing
      SELinux: flush the avc before disabling SELinux

 include/linux/cred.h       |   13 ++++++++-----
 include/linux/selinux.h    |    9 +++++++++
 security/selinux/avc.c     |   26 +++++++++++++++++++-------
 security/selinux/exports.c |    6 ++++++
 4 files changed, 42 insertions(+), 12 deletions(-)

-- 
James Morris
<jmorris@namei.org>
