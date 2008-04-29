Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYD2SIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYD2SIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYD2SI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:08:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53634 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbYD2SI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:08:26 -0400
Date: Tue, 29 Apr 2008 19:08:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] audit patches
Message-ID: <20080429180825.GO5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted audit patches for this cycle.  Please, pull from
git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b50

Shortlog:
Al Viro (1):
      new predicate - AUDIT_FILETYPE

Eric Paris (7):
      Audit: end printk with newline
      Audit: collect sessionid in netlink messages
      Audit: save audit_backlog_limit audit messages in case auditd comes back
      Audit: stop deadlock from signals under load
      Audit: standardize string audit interfaces
      Audit: increase the maximum length of the key field
      Audit: MAINTAINERS update

Harvey Harrison (2):
      audit: move extern declarations to audit.h
      audit: fix sparse shadowed variable warnings

Miloslav Trmac (1):
      [patch 1/2] audit: let userspace fully control TTY input auditing

Pavel Emelyanov (1):
      [patch 2/2] Use find_task_by_vpid in audit code

Diffstat:
 MAINTAINERS                       |    8 +-
 drivers/char/tty_audit.c          |   63 +---------
 drivers/char/tty_io.c             |    5 +-
 include/linux/audit.h             |   28 +++--
 include/linux/netlink.h           |    1 +
 include/linux/tty.h               |    9 +-
 include/net/netlabel.h            |    1 +
 include/net/xfrm.h                |   23 ++--
 kernel/audit.c                    |  249 +++++++++++++++++++++++++-----------
 kernel/audit.h                    |   13 ++
 kernel/auditfilter.c              |   45 ++++---
 kernel/auditsc.c                  |   40 ++++---
 net/key/af_key.c                  |   17 ++-
 net/netlabel/netlabel_unlabeled.c |    1 +
 net/netlabel/netlabel_user.c      |    4 +-
 net/netlabel/netlabel_user.h      |    1 +
 net/netlink/af_netlink.c          |    1 +
 net/xfrm/xfrm_policy.c            |   12 ++-
 net/xfrm/xfrm_state.c             |   13 ++-
 net/xfrm/xfrm_user.c              |   41 ++++--
 security/selinux/avc.c            |    2 +-
 security/smack/smackfs.c          |    2 +
 22 files changed, 346 insertions(+), 233 deletions(-)

