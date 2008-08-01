Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbYHAQUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbYHAQUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbYHAQUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:20:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59556 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbYHAQT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:19:59 -0400
Date: Fri, 1 Aug 2008 17:19:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] audit fixes
Message-ID: <20080801161958.GQ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Misc audit fixes.  Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b54

Shortlog:
Eric Paris (1):
      Audit: Collect signal info when SIGUSR2 is sent to auditd

Vesa-Matti J Kari (1):
      kernel/audit.c control character detection is off-by-one

zhangxiliang (3):
      Re: [PATCH] the loginuid field should be output in all AUDIT_CONFIG_CHANGE audit messages
      Fix the kernel panic of audit_filter_task when key field is set
      Fix the bug of using AUDIT_STATUS_RATE_LIMIT when set fail, no error output.

Diffstat:
 kernel/audit.c       |   13 +++++++++----
 kernel/auditfilter.c |   10 ++++++++--
 kernel/auditsc.c     |    4 ++--
 3 files changed, 19 insertions(+), 8 deletions(-)
