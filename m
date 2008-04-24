Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYDXWOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYDXWOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbYDXWOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:14:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:41814 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbYDXWOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:14:15 -0400
Message-ID: <48110631.7000106@windriver.com>
Date: Thu, 24 Apr 2008 17:14:09 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [git pull] kgdb fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2008 22:14:06.0392 (UTC) FILETIME=[82EC5B80:01C8A658]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the latest kgdb fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

These are some cleanups from the initial kgdb merge.

Thanks,
Jason.


Harvey Harrison (2):
      kgdb: trivial sparse fixes in kgdb test-suite
      kgdb: fix signedness mixmatches, add statics, add declaration to header

Jason Wessel (1):
      kgdb: 1000 loops for the single step test in kgdbts

grzegorz.chwesewicz@chilan.com (1):
      kgdb: minor documentation fixes

 Documentation/DocBook/kgdb.tmpl |    8 +++--
 drivers/misc/kgdbts.c           |   75 ++++++++++++++++++++++----------------
 include/linux/kgdb.h            |    4 ++-
 kernel/kgdb.c                   |    8 ++--
 4 files changed, 55 insertions(+), 40 deletions(-)
