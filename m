Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbZIPNvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbZIPNvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZIPNvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:51:40 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:44542
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752746AbZIPNvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:51:38 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQ2H5S-03-4MO-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <torvalds@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: <norsk5@yahoo.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [GIT PULL] AMD64 EDAC updates, p2
Date: Wed, 16 Sep 2009 15:50:45 +0200
Message-ID: <1253109050-31165-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 16 Sep 2009 13:51:19.0691 (UTC) FILETIME=[C4D795B0:01CA36D4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the second update for EDAC which include proper build fixes
for AMD64 EDAC module and EDAC MCE code and some cleanups. There is
still some more minor stuff pending which depends on patches in -tip but
I'll push it later on.

Thanks.

The following changes since commit 0cb583fd2862f19ea88b02eb307d11c09e51e2f8:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-next-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Andreas Herrmann (1):
      x86, EDAC: Provide function to return NodeId of a CPU

Borislav Petkov (2):
      amd64_edac: cleanup amd64_check_ecc_enabled
      amd64_edac: check NB MCE bank enable on the current node properly

Ingo Molnar (1):
      amd64_edac: build driver only on AMD hardware

Wan Wei (1):
      amd64_edac: Rewrite unganged mode code of f10_early_channel_count

 arch/x86/include/asm/processor.h |    2 +
 arch/x86/kernel/cpu/amd.c        |   10 ++
 drivers/edac/Kconfig             |    2 +-
 drivers/edac/amd64_edac.c        |  175 ++++++++++++++++----------------------
 drivers/edac/edac_mce_amd.c      |    2 +-
 5 files changed, 88 insertions(+), 103 deletions(-)

