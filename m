Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbXIQL3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbXIQL3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbXIQL3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:29:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbXIQL3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:29:19 -0400
Date: Mon, 17 Sep 2007 07:29:05 -0400
Message-Id: <200709171129.l8HBT5Kq024360@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 0/7] fix setuid/setgid clearing in networked filesystems (take 6)
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net,
       ecryptfs-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org,
       unionfs@filesystems.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is the latest one for fixing the clearing of setuid/setgid
bits in networked filesystems. It should apply cleanly to 2.6.23-rc4-mm1.
This is basically the same patchset as take 5. The main differences are
that the patches have been reordered to make the tree cleanly bisectable,
and the comment in notify_change is now a bit more descriptive. I've also
moved the description of the main rationale for the patch into patch 5.

Andrew, would it be possible to go ahead and get this committed to -mm?

Signed-off-by: Jeff Layton <jlayton@redhat.com>
