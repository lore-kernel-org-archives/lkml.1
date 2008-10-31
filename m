Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYJaGDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYJaGDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 02:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYJaGDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 02:03:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39657
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbYJaGDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 02:03:21 -0400
Date: Thu, 30 Oct 2008 23:02:56 -0700 (PDT)
Message-Id: <20081030.230256.167447008.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some fixes and tidies:

1) RTC m48t59 century bit handling fix from Krzysztof Helt

2) Byte ordering tidies from Harvey Harrison
   a) PIO string ops don't need to use explicit byte shifting
   b) sparc can easily use the new byteorder headers

3) dbri sound driver doesn't check for dma_alloc_coherent() error
   returns, from FUJITA Tomonori

4) Device ID table for bq4802 RTC chip lacks a terminating NULL entry.

Please pull, thanks a lot!

The following changes since commit 60b8267338aafde5315fc65ff385f3d4d75eccfe:
  David S. Miller (1):
        math-emu: Fix thinko in _FP_DIV

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Add missing null terminating entry to bq4802_match[].

FUJITA Tomonori (1):
      dbri: check dma_alloc_coherent errors

Harvey Harrison (2):
      sparc64: remove byteshifting from out* helpers
      sparc: use the new byteorder headers

Krzysztof Helt (1):
      rtc-m48t59: shift zero year to 1968 on sparc (rev 2)

 arch/sparc/include/asm/byteorder.h |   22 ++----
 arch/sparc/kernel/time.c           |   27 +------
 arch/sparc64/kernel/time.c         |   34 ++-------
 arch/sparc64/lib/PeeCeeI.c         |  139 ++++++++++++------------------------
 drivers/rtc/rtc-m48t59.c           |   34 ++++++++-
 sound/sparc/dbri.c                 |    2 +
 6 files changed, 97 insertions(+), 161 deletions(-)

