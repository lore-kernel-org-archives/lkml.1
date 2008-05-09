Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbYEIAGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbYEIAGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbYEIAFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:05:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49774
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754322AbYEIAFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:05:51 -0400
Date: Thu, 08 May 2008 17:05:45 -0700 (PDT)
Message-Id: <20080508.170545.193703278.davem@davemloft.net>
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


Please pull to get this sparc signal stack handling bug fix.

Thanks!

The following changes since commit 1e38c126c9252b612697e34f43b1b3371c8ee31d:
  David S. Miller (1):
        sparc: Fix fork/clone/vfork system call restart.

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc: Fix SA_ONSTACK signal handling.

 arch/sparc/kernel/signal.c     |   20 +++++++++++++++++---
 arch/sparc64/kernel/signal.c   |   21 +++++++++++++++++----
 arch/sparc64/kernel/signal32.c |   18 +++++++++++++++++-
 3 files changed, 51 insertions(+), 8 deletions(-)
