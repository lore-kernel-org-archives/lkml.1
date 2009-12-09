Return-Path: <linux-kernel-owner+w=401wt.eu-S1752200AbZLIIww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbZLIIww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZLIIwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:52:50 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:44800
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751758AbZLIIwt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:52:49 -0500
X-SpamScore: 7
X-BigFish: VPS7(z37d4lzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KUDNBT-02-ANL-02
X-M-MSG: 
Date: Wed, 9 Dec 2009 09:52:27 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: [GIT PULL] amd64_edac updates for .33
Message-ID: <20091209085227.GB16385@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 09 Dec 2009 08:52:27.0798 (UTC) FILETIME=[EF4CDB60:01CA78AC]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the git repo below the following amd64 edac driver
updates. Highlights are DDR3 support, error syndromes decoding and a big
bunch of cleanups.

Thanks.

The following changes since commit 6ec22f9b037fc0c2e00ddb7023fad279c365324d:
  Linus Torvalds (1):
        Merge branch 'x86-debug-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Andrew Morton (1):
      amd64_edac: fix use-uninitialised bug

Borislav Petkov (19):
      amd64_edac: clarify DRAM CTL debug reporting
      amd64_edac: make DRAM regions output more human-readable
      amd64_edac: unify MCGCTL ECC switching
      amd64_edac: wrap-up pci config read error handling
      amd64_edac: cleanup DRAM cfg low debug output
      amd64_edac: cleanup rest of amd64_dump_misc_regs
      amd64_edac: dump DIMM sizes on K8 too
      amd64_edac: cleanup f10_early_channel_count
      amd64_edac: enhance address to DRAM bank mapping
      amd64_edac: remove superfluous dbg printk
      amd64_edac: rename StinkyIdentifier
      amd64_edac: remove unneeded extract_error_address wrapper
      edac, mce: update AMD F10h revD check
      edac: add memory types strings for debugging
      amd64_edac: detect DDR3 memory type
      amd64_edac: remove early hw support check
      amd64_edac: add a leaner syndrome decoding algorithm
      amd64_edac: correct sys address to chip select mapping
      amd64_edac: bump driver version

Rusty Russell (1):
      cpumask: use modern cpumask style in drivers/edac/amd64_edac.c

 drivers/edac/amd64_edac.c   | 1251 +++++++++++++++++++------------------------
 drivers/edac/amd64_edac.h   |   62 ++-
 drivers/edac/edac_core.h    |    1 +
 drivers/edac/edac_mc.c      |   24 +
 drivers/edac/edac_mce_amd.c |    2 +-
 5 files changed, 621 insertions(+), 719 deletions(-)

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

