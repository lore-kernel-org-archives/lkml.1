Return-Path: <linux-kernel-owner+w=401wt.eu-S1762525AbZFKKh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762525AbZFKKh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760882AbZFKKhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:37:16 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:2546 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760519AbZFKKhO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:37:14 -0400
X-SpamScore: -19
X-BigFish: VPS-19(z21eWz936eNzz1202hzzz32i6bh17ch6di61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KL2LHS-02-80E-01
Date: Thu, 11 Jun 2009 12:37:05 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] AMD64 EDAC module for 2.6.31
Message-ID: <20090611103705.GC15454@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-OriginalArrivalTime: 11 Jun 2009 10:37:05.0483 (UTC) FILETIME=[9052D1B0:01C9EA80]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

following Andrew's suggestion, I'd like to request a pull :) for the
AMD64 EDAC stuff we've been working on in the last couple of weeks. The
patches have been reviewed by lots of people and all their concerns have
been addressed. Furthermore, the patchset has been brewing for a while
in linux-next and, as a result, has gained couple of Kconfig build fixes
and cleanups.

Thanks.

The following changes since commit 07a2039b8eb0af4ff464efd3dfd95de5c02648c6:
  Linus Torvalds (1):
        Linux 2.6.30

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (6):
      x86: MSR: add a struct representation of an MSR
      x86: MSR: add methods for writing of an MSR on several CPUs
      edac: fold __func__ into edac_debug_printk
      amd64_edac: do not enable module by default
      EDAC: do not enable modules by default
      amd64_edac: add MAINTAINERS entry

Doug Thompson (20):
      amd64_edac: add driver header
      amd64_edac: add debugging/testing code
      amd64_edac: add DRAM error injection logic using sysfs
      amd64_edac: add MCA error types
      amd64_edac: add memory scrubber interface
      amd64_edac: add sys addr to memory controller mapping helpers
      amd64_edac: add functionality to compute the DRAM hole
      amd64_edac: add DRAM address type conversion facilities
      amd64_edac: add helper to dump relevant registers
      amd64_edac: assign DRAM chip select base and mask in a family-specific way
      amd64_edac: add k8-specific methods
      amd64_edac: add F10h-and-later methods-p1
      amd64_edac: add F10h-and-later methods-p2
      amd64_edac: add F10h-and-later methods-p3
      amd64_edac: add per-family descriptors
      amd64_edac: add ECC chipkill syndrome mapping table
      amd64_edac: add error decoding logic
      amd64_edac: add EDAC core-related initializers
      amd64_edac: add ECC reporting initializers
      amd64_edac: add module registration routines

 MAINTAINERS                         |   10 +
 arch/x86/include/asm/msr.h          |   23 +
 arch/x86/lib/Makefile               |    2 +-
 arch/x86/lib/msr-on-cpu.c           |   97 -
 arch/x86/lib/msr.c                  |  183 ++
 drivers/edac/Kconfig                |   26 +-
 drivers/edac/Makefile               |    7 +
 drivers/edac/amd64_edac.c           | 3354 +++++++++++++++++++++++++++++++++++
 drivers/edac/amd64_edac.h           |  644 +++++++
 drivers/edac/amd64_edac_dbg.c       |  255 +++
 drivers/edac/amd64_edac_err_types.c |  161 ++
 drivers/edac/amd64_edac_inj.c       |  185 ++
 drivers/edac/edac_core.h            |    9 +-
 13 files changed, 4853 insertions(+), 103 deletions(-)
 delete mode 100644 arch/x86/lib/msr-on-cpu.c
 create mode 100644 arch/x86/lib/msr.c
 create mode 100644 drivers/edac/amd64_edac.c
 create mode 100644 drivers/edac/amd64_edac.h
 create mode 100644 drivers/edac/amd64_edac_dbg.c
 create mode 100644 drivers/edac/amd64_edac_err_types.c
 create mode 100644 drivers/edac/amd64_edac_inj.c

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

