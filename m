Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZLXKO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZLXKO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 05:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbZLXKO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 05:14:58 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:58676
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751238AbZLXKO5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 05:14:57 -0500
X-SpamScore: -13
X-BigFish: VPS-13(z21eWzzz1202hzzz32i6bh308i61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KV5J4O-02-JNL-02
X-M-MSG: 
Date: Thu, 24 Dec 2009 11:14:52 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Doug Thompson <norsk5@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD64 EDAC fixes for 2.6.33-rc2
Message-ID: <20091224101452.GA27862@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 24 Dec 2009 10:14:49.0100 (UTC) FILETIME=[ECBDF4C0:01CA8481]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull a bunch of fixes to several edac buglets and annoyances
alongside two fixes to reported problems.

Thanks.

The following changes since commit 2f99f5c8f05e02f3df1bb4d93b6704e6f5972872:
  Linus Torvalds (1):
        Revert "x86, ucode-amd: Ensure ucode update on suspend/resume after CPU off/online cycle"

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (6):
      amd64_edac: fix K8 chip select reporting
      amd64_edac: fix driver instance freeing
      amd64_edac: make driver loading more robust
      amd64_edac: fix forcing module load/unload
      amd64_edac: restrict PCI config space access
      edac, pci: remove pesky debug printk

 drivers/edac/amd64_edac.c     |   45 +++++++++++++++++++++++++---------------
 drivers/edac/edac_pci_sysfs.c |    2 -
 2 files changed, 28 insertions(+), 19 deletions(-)

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

