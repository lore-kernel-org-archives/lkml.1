Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbZDETSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbZDETSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 15:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZDETSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 15:18:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32874 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbZDETR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 15:17:59 -0400
Date: Sun, 5 Apr 2009 20:17:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] audit patches
Message-ID: <20090405191757.GB26366@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, pull from
git//git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b62

Shortlog:
Eric Paris (2):
      audit: incorrect ref counting in audit tree tag_chunk
      audit: audit_set_auditable defined but not used

Jiri Pirko (1):
      audit: EXECVE record - removed bogus newline

Miloslav Trmac (2):
      Audit: fix handling of 'strings' with NULL characters
      audit: ignore terminating NUL in AUDIT_USER_TTY messages

Paul Moore (1):
      audit: Fix possible return value truncation in audit_get_context()

Randy Dunlap (1):
      auditsc: fix kernel-doc notation

Zhenwen Xu (1):
      make the e->rule.xxx shorter in kernel auditfilter.c

Diffstat:
 kernel/audit.c       |    5 ++++-
 kernel/audit_tree.c  |    2 ++
 kernel/auditfilter.c |   16 ++++++++--------
 kernel/auditsc.c     |   31 +++++++++++++++----------------
 4 files changed, 29 insertions(+), 25 deletions(-)
