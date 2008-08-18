Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbYHRFjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbYHRFjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 01:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYHRFjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 01:39:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50020
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbYHRFjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 01:39:05 -0400
Date: Sun, 17 Aug 2008 22:39:04 -0700 (PDT)
Message-Id: <20080817.223904.186713151.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The LMB bug fix was OK'd by the powerpc folks and they are the
only other port which uses that code, so... :-)

Please pull, thanks a lot!

The following changes since commit 6f63e781eaf6a741fc65f773017154b20ed4ce3b:
  David S. Miller (1):
        sparc64: Handle stack trace attempts before irqstacks are setup.

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (3):
      sparc64: Fix overshoot in nid_range().
      sparc64: Fix cmdline_memory_size handling bugs.
      lmb: Fix reserved region handling in lmb_enforce_memory_limit().

 arch/sparc64/mm/init.c |   30 ++++++++++++++++++++++--------
 lib/lmb.c              |    2 ++
 2 files changed, 24 insertions(+), 8 deletions(-)
