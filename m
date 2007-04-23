Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbXDWOLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbXDWOLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 10:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXDWOLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 10:11:09 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:8707 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbXDWOLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 10:11:07 -0400
Date: Mon, 23 Apr 2007 16:11:23 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: akpm@linux-foundation.org, mb@bu3sch.de, linville@tuxdriver.com,
       arnd@arndb.de, maxextreme@gmail.com, gregkh@suse.de
Subject: [PATCH 0/9] Kconfig: cleanup s390 v2.
Message-ID: <20070423141123.GA21174@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
I've added the results of the review to the Kconfig cleanup patches
for s390. Patch #2 has been split, one half has all the HAS_IOMEM
depends lines the other the remaining !S390 depends lines.

Andrew: I plan to add patches 1-5 to the for-andrew branch of the
git390 repository if that is fine with you. The only thing that will
be missing in the tree is the patch that disables wireless for s390.
The code does compile but without hardware it is mute to have the
config options. I'll wait until the git-wireless.patch is upstream.
Patches 7-9 depend on patches found in -mm.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.

