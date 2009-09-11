Return-Path: <linux-kernel-owner+w=401wt.eu-S1752086AbZIKMJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbZIKMJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 08:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZIKMI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 08:08:59 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:57104 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbZIKMI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 08:08:59 -0400
Subject: [GIT PULL] Kmemleak patches
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 11 Sep 2009 13:08:54 +0100
Message-Id: <1252670934.29620.23.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Sep 2009 12:08:55.0170 (UTC) FILETIME=[A25B5620:01CA32D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please merge the kmemleak branch? It contains a few new
features and some fixes but no major changes. Thanks.

The following changes since commit 1e23502cc57cef33455ac7cb9111e3c6d991a894:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://linux-arm.org/linux-2.6.git kmemleak

Catalin Marinas (9):
      kmemleak: Allow rescheduling during an object scanning
      kmemleak: Dump object information on request
      kmemleak: Mark the early log buffer as __initdata
      kmemleak: Save the stack trace for early allocations
      kmemleak: Do not report alloc_bootmem blocks as leaks
      kmemleak: Ignore the aperture memory hole on x86_64
      kmemleak: Scan all thread stacks
      kmemleak: Do no create the clean-up thread during kmemleak_disable()
      kmemleak: Improve the "Early log buffer exceeded" error message

Luis R. Rodriguez (5):
      kmemleak: use bool for true/false questions
      kmemleak: add clear command support
      kmemleak: move common painting code together
      kmemleak: fix sparse warning over overshadowed flags
      kmemleak: fix sparse warning for static declarations

Pekka Enberg (1):
      kmemleak: Don't scan uninitialized memory when kmemcheck is enabled

Sergey Senozhatsky (1):
      kmemleak: Printing of the objects hex dump

 Documentation/kmemleak.txt        |   31 ++++
 arch/x86/kernel/aperture_64.c     |    6 +
 arch/x86/kernel/pci-dma.c         |    6 +
 arch/x86/mm/kmemcheck/kmemcheck.c |   14 ++
 include/linux/kmemcheck.h         |    7 +
 include/linux/kmemleak.h          |   18 +-
 mm/bootmem.c                      |    6 +-
 mm/kmemleak.c                     |  336 +++++++++++++++++++++++++++----------
 8 files changed, 323 insertions(+), 101 deletions(-)

-- 
Catalin

