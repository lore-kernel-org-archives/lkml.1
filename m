Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYIVBiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYIVBiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 21:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYIVBiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 21:38:16 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41749 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbYIVBiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 21:38:16 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-MM <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 0/2] Report the pagesize backing VMAs in /proc
Date: Mon, 22 Sep 2008 02:38:10 +0100
Message-Id: <1222047492-27622-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches add support for printing the size used for
hugepage-backed regions. This can be used by a user to verify that a
hugepage-aware application is using the expected page sizes.

The first patch should not be considered too contensious as it is highly
unlikely to break any parsers. There is a possibility that the second patch
will break parsers that arguably are already broken. More details are in
the patches themselves.

 fs/proc/task_mmu.c      |   29 +++++++++++++++++++++--------
 include/linux/hugetlb.h |   13 +++++++++++++
 2 files changed, 34 insertions(+), 8 deletions(-)

