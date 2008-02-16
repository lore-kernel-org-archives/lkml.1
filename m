Return-Path: <linux-kernel-owner+w=401wt.eu-S1764525AbYBPCKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764525AbYBPCKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 21:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763974AbYBPCKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 21:10:08 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:61270 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758897AbYBPCJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 21:09:35 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [GIT PATCH 0/2] ocfs2: Fix endian bug in o2dlm negotiation
Date: Fri, 15 Feb 2008 18:07:31 -0800
Message-Id: <1203127653-4617-1-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.3.4
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These patches fix up two outstanding issues from commit
d24fbcda0c4988322949df3d759f1cfb32b32953 (ocfs2: Negotiate locking
protocol versions).  The first patch cleans up the comparison functions
based on Andrew's review.  The second fixes a byte-order bug in
heterogeneous clusters.

I've tested the changes in said hetergeneous envirnoment.  Comments
and review welcome.  Mark, you can pull these into ocfs2.git if they
meet your approval.

The changes are available via git from
git://oss.oracle.com/git/jlbec/linux-2.6.git proto-version-fixup

Joel

