Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbYELH6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbYELH6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYELH6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:58:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35359
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751221AbYELH6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:58:14 -0400
Date: Mon, 12 May 2008 00:58:09 -0700 (PDT)
Message-Id: <20080512.005809.226545939.davem@davemloft.net>
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


We have a 64-bit memory probing fix, and two 32-bit build fixes
from Robert Reif.

I'm still working on Mikael P's memory probing problem, which is
on the regression list.

Please pull, thanks a lot!

The following changes since commit 28e6103665301ce60634e8a77f0b657c6cc099de:
  David S. Miller (1):
        sparc: Fix debugger syscall restart interactions.

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Work around memory probing bug in openfirmware.

Robert Reif (2):
      sparc32: Fix build.
      sparc32: fix rtrap.S typo

 arch/sparc/kernel/rtrap.S  |    2 +-
 arch/sparc64/mm/init.c     |   16 +++++++++++-----
 include/asm-sparc/ptrace.h |    2 ++
 3 files changed, 14 insertions(+), 6 deletions(-)
