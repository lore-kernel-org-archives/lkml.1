Return-Path: <linux-kernel-owner+w=401wt.eu-S937147AbXGQXs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937147AbXGQXs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760409AbXGQXsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:48:13 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:38652 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824AbXGQXsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:48:11 -0400
Date: Tue, 17 Jul 2007 19:48:08 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Paul Moore <paul.moore@hp.com>,
       linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com
Subject: [PATCH 0/2] SELinux Netlabel updates
Message-ID: <Line.LNX.4.64.0707171945430.10858@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are updated Netlabel/SELinux changes from Paul, reworked so that 
they don't break userspace.  Michal says they work for him.  Please apply 
for 2.6.23.



The following changes since commit 489de30259e667d7bc47da9da44a0270b050cd97:
  Linus Torvalds (1):
        Merge branch 'merge' of git://git.kernel.org/.../paulus/powerpc

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-linus

Paul Moore (2):
      SELinux: enable dynamic activation/deactivation of NetLabel/SELinux enforcement
      SELinux: use SECINITSID_NETMSG instead of SECINITSID_UNLABELED for NetLabel

 include/net/netlabel.h           |    6 +++
 net/netlabel/netlabel_cipso_v4.c |    5 +++
 net/netlabel/netlabel_kapi.c     |   21 ++++++++++++
 net/netlabel/netlabel_mgmt.c     |   65 ++++++++++++++++++++++++++++++++++++++
 net/netlabel/netlabel_mgmt.h     |    5 +++
 security/selinux/hooks.c         |   21 ++++++------
 security/selinux/netlabel.c      |   49 ++++++++++++++++------------
 7 files changed, 141 insertions(+), 31 deletions(-)

-- 
James Morris
<jmorris@namei.org>
