Return-Path: <linux-kernel-owner+w=401wt.eu-S1762107AbZEONTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762107AbZEONTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760546AbZEONS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:18:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:34692 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760545AbZEONSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:18:55 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [git pull] kgdb 2.6.30-rc5 regression fixes
Date: Fri, 15 May 2009 08:17:56 -0500
Message-Id: <1242393479-19351-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
X-OriginalArrivalTime: 15 May 2009 13:18:10.0658 (UTC) FILETIME=[98103C20:01C9D55F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the kgdb git tree fixes for 2.6.30-rc5

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

These are 3 kgdb regressions that have had fixes for some time.  They
are all well tested so it would be worth it to get them merged.

The piece that touches the sysrq change was already reviewed by the
owners of the code and includes the appropriate ack's.

Thanks,
Jason.

Short log follows:

Frank Rowand (1):
      kgdb: gdb documentation fix

Jason Wessel (2):
      sysrq, intel_fb: fix sysrq g collision
      kgdb,i386: use address that SP register points to in the exception frame

 Documentation/DocBook/kgdb.tmpl |    2 +-
 arch/x86/kernel/kgdb.c          |    3 ++-
 drivers/char/sysrq.c            |    4 ++--
 drivers/gpu/drm/i915/intel_fb.c |    4 ++--
 kernel/kgdb.c                   |    4 ++--
 5 files changed, 9 insertions(+), 8 deletions(-)
