Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbZIOALv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbZIOALv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 20:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbZIOALu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 20:11:50 -0400
Received: from tundra.namei.org ([65.99.196.166]:54872 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbZIOALt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 20:11:49 -0400
Date: Tue, 15 Sep 2009 10:10:43 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Eric Paris <eparis@redhat.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT] security / creds fixes
In-Reply-To: <20090914162613.9016.79225.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.0909151008440.11936@tundra.namei.org>
References: <20090914162613.9016.79225.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated pull request, with David's latest patches incorporated.  

(The previous pull url still works, this is branched from that with the 
new patches added).

Please pull this if you haven't pulled the other one already.


The following changes since commit 86d710146fb9975f04c505ec78caa43d227c1018:
  Linus Torvalds (1):
        Merge git://git.linux-nfs.org/projects/trondmy/nfs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus2

David Howells (2):
      CRED: Allow put_cred() to cope with a NULL groups list
      KEYS: Fix garbage collector

Eric Paris (3):
      Creds: creds->security can be NULL is selinux is disabled
      SELinux: seperate avc_cache flushing
      SELinux: flush the avc before disabling SELinux

Marc Dionne (1):
      KEYS: Unlock tasklist when exiting early from keyctl_session_to_parent

 include/linux/cred.h       |   13 ++++---
 include/linux/selinux.h    |    9 +++++
 kernel/cred.c              |    3 +-
 security/keys/gc.c         |   78 ++++++++++++++++++++++++++++---------------
 security/keys/key.c        |    4 +-
 security/keys/keyctl.c     |    3 +-
 security/keys/keyring.c    |   24 +++++++++++---
 security/selinux/avc.c     |   26 +++++++++++----
 security/selinux/exports.c |    6 +++
 9 files changed, 118 insertions(+), 48 deletions(-)


-- 
James Morris
<jmorris@namei.org>
