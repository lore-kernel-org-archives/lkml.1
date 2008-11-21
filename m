Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYKUPoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYKUPoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYKUPoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:44:11 -0500
Received: from smtp.nokia.com ([192.100.122.233]:58957 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYKUPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:44:09 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: UBIFS updates for 2.6.28
Date: Fri, 21 Nov 2008 19:19:22 +0200
Message-Id: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
X-OriginalArrivalTime: 21 Nov 2008 15:44:05.0929 (UTC) FILETIME=[FC525190:01C94BEF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are the UBIFS fixes we have scheduled for 2.6.28. We are
planning to send them to Linus a little bit later. I send them
for your review.

The "UBIFS: allow for gaps when dirtying the LPT" patch solves
the problem reported by Deepak Saxena.

The "UBIFS: remove printk" fixes a little bit annoying message
from UBIFS which comes every time we re-mount the FS.

The "UBIFS: do not print scary memory allocation warnings",
    "UBIFS: do not allocate too much", and
    "UBIFS: pre-allocate bulk-read buffer"
fix UBIFS memory allocation problems when bulk-read is enabled.


Adrian Hunter (1):
      UBIFS: allow for gaps when dirtying the LPT

Artem Bityutskiy (6):
      UBIFS: remove printk
      MAINTAINERS: change UBI/UBIFS git tree URLs
      UBIFS: fix compilation warnings
      UBIFS: do not print scary memory allocation warnings
      UBIFS: do not allocate too much
      UBIFS: pre-allocate bulk-read buffer

Harvey Harrison (1):
      UBIFS: endian handling fixes and annotations

 MAINTAINERS           |    4 +-
 fs/ubifs/commit.c     |    4 +-
 fs/ubifs/debug.c      |   66 +++++++++++++++++++++--------------
 fs/ubifs/dir.c        |    5 ++-
 fs/ubifs/file.c       |   91 ++++++++++++++++++++++++++++++++++---------------
 fs/ubifs/journal.c    |    8 +++--
 fs/ubifs/key.h        |    4 +-
 fs/ubifs/lpt_commit.c |    2 -
 fs/ubifs/orphan.c     |   28 +++++++++------
 fs/ubifs/recovery.c   |   17 +++++----
 fs/ubifs/replay.c     |    2 +-
 fs/ubifs/sb.c         |    9 +++--
 fs/ubifs/super.c      |   70 +++++++++++++++++++++++++++++++------
 fs/ubifs/tnc.c        |   12 +++++--
 fs/ubifs/ubifs.h      |   12 +++++--
 15 files changed, 223 insertions(+), 111 deletions(-)

--
Best regards,
Artem Bityutskiy (Битюцкий Артём)
