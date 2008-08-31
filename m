Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbYHaNOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbYHaNOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758777AbYHaNOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:14:43 -0400
Received: from smtp.nokia.com ([192.100.122.233]:61148 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715AbYHaNOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:14:42 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: UBIFS updates for 2.6.27
Date: Sun, 31 Aug 2008 17:52:34 +0300
Message-Id: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
X-OriginalArrivalTime: 31 Aug 2008 13:14:25.0462 (UTC) FILETIME=[7DAC4D60:01C90B6B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the second bunch of UBIFS updates we would like to send to
Linus for 2.6.27 inclusion. The updates contain the following:

Adrian Hunter (2):
      UBIFS: always read hashed-key nodes under TNC mutex
      UBIFS: allow for racing between GC and TNC

Artem Bityutskiy (10):
      UBIFS: fix zero-length truncations
      UBIFS: do not update min_idx_lebs in stafs
      UBIFS: push empty flash hack down
      UBIFS: remove incorrect index space check
      UBIFS: improve statfs reporting
      UBIFS: fix assertion
      UBIFS: add forgotten gc_idx_lebs component
      UBIFS: introduce LEB overhead
      UBIFS: improve statfs reporting even more
      UBIFS: fill f_fsid

 fs/ubifs/budget.c |  113 +++++++++++++++++++++++++++++++++++++++------------
 fs/ubifs/dir.c    |    1 -
 fs/ubifs/file.c   |   20 +++++++--
 fs/ubifs/find.c   |   18 ++++-----
 fs/ubifs/gc.c     |    6 +++
 fs/ubifs/misc.h   |   49 ++++++++---------------
 fs/ubifs/super.c  |   19 +++++---
 fs/ubifs/tnc.c    |  116 ++++++++++++++++++++++++++++-------------------------
 fs/ubifs/ubifs.h  |   14 +++++-
 9 files changed, 217 insertions(+), 139 deletions(-)

These patches are pure fixes:
UBIFS: fix zero-length truncations
UBIFS: always read hashed-key nodes under TNC mutex
UBIFS: allow for racing between GC and TNC
UBIFS: fix assertion
UBIFS: add forgotten gc_idx_lebs component
UBIFS: remove incorrect index space check

These patches partially fix the problem reported in the MTD ML:
http://lists.infradead.org/pipermail/linux-mtd/2008-August/022579.html

UBIFS: do not update min_idx_lebs in stafs
UBIFS: push empty flash hack down
UBIFS: improve statfs reporting
UBIFS: introduce LEB overhead
UBIFS: improve statfs reporting even more

Thus, it should be fine to send them mainline at this late stage.
Unless there are complaints, I'll send a pull request soon.

Thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)
