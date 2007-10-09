Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbXJIXTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbXJIXTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbXJIXTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:19:08 -0400
Received: from namei.org ([69.55.235.186]:44098 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751300AbXJIXTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:19:07 -0400
Date: Wed, 10 Oct 2007 09:18:37 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 0/6] SELinux patches for 2.6.24
Message-ID: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull.


The following changes since commit bbf25010f1a6b761914430f5fca081ec8c7accd1:
  Linus Torvalds (1):
        Linux 2.6.23

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git for-linus

Eric Paris (2):
      SELinux: change Kconfig to use select instead of depends
      SELinux: policy selectable handling of unknown classes and perms

KaiGai Kohei (2):
      SELinux: improve performance when AVC misses.
      SELinux: kills warnings in Improve SELinux performance when AVC misses

Yuichi Nakamura (2):
      SELinux: tune avtab to reduce memory usage
      SELinux: Improve read/write performance

 fs/open.c                           |    4 +
 include/linux/security.h            |   18 +++
 security/dummy.c                    |    6 +
 security/selinux/Kconfig            |    7 +-
 security/selinux/avc.c              |    5 +
 security/selinux/hooks.c            |   53 +++++++-
 security/selinux/include/avc.h      |    2 +
 security/selinux/include/objsec.h   |    2 +
 security/selinux/include/security.h |    2 +
 security/selinux/selinuxfs.c        |   26 ++++
 security/selinux/ss/avtab.c         |   91 ++++++++----
 security/selinux/ss/avtab.h         |   16 ++-
 security/selinux/ss/conditional.c   |    4 +
 security/selinux/ss/ebitmap.c       |  282 +++++++++++++++++++---------------
 security/selinux/ss/ebitmap.h       |   89 +++++++++---
 security/selinux/ss/mls.c           |  156 +++++++++----------
 security/selinux/ss/policydb.c      |   11 +-
 security/selinux/ss/policydb.h      |    8 +
 security/selinux/ss/services.c      |   91 +++++++++---
 19 files changed, 588 insertions(+), 285 deletions(-)
