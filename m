Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbZINRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbZINRTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbZINRTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:19:16 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:17283
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751738AbZINRTQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:19:16 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMzz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KPZ1FS-02-F4T-02
X-M-MSG: 
Date: Mon, 14 Sep 2009 19:19:05 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: x86 <x86@kernel.org>, Doug Thompson <norsk5@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] AMD64 EDAC updates, p1
Message-ID: <20090914171905.GD13615@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 Sep 2009 17:19:05.0655 (UTC) FILETIME=[764F3C70:01CA355F]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the first (of two) AMD64 EDAC update sets. This one
adds MCE decoding functionality to the EDAC core and has been
simmering for a while now in linux-next. The next one will be
forthcoming in the next couple of days and will contain more general
cleanups/improvements/bugfixes.

Thanks.

The following changes since commit 74fca6a42863ffacaf7ba6f1936a9f228950f657:
  Linus Torvalds (1):
        Linux 2.6.31

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (15):
      EDAC: move MCE error descriptions to EDAC core
      EDAC: beef up ErrorCodeExt error signatures
      amd64_edac: cleanup amd64_process_error_info
      amd64_edac: cleanup/complete NB MCE decoding
      amd64_edac: remove memory and GART TLB error decoders
      amd64_edac: cleanup amd64_decode_bus_error
      x86, mce: pass mce info to EDAC for decoding
      EDAC, AMD: carve out MCi_STATUS decoding
      EDAC, AMD: carve out decoding of MCi_STATUS ErrorCode
      EDAC, AMD: decode data cache MCEs
      EDAC, AMD: decode instruction cache MCEs
      EDAC, AMD: decode bus unit MCEs
      EDAC, AMD: decode load store MCEs
      EDAC, AMD: decode FR MCEs
      x86, mce: do not compile mcelog message on AMD

 arch/x86/kernel/cpu/mcheck/mce.c    |   12 +-
 drivers/edac/Makefile               |    6 +-
 drivers/edac/amd64_edac.c           |  328 +++++++++------------------
 drivers/edac/amd64_edac.h           |   71 +------
 drivers/edac/amd64_edac_dbg.c       |    2 +-
 drivers/edac/amd64_edac_err_types.c |  161 -------------
 drivers/edac/edac_mce_amd.c         |  422 +++++++++++++++++++++++++++++++++++
 drivers/edac/edac_mce_amd.h         |   69 ++++++
 8 files changed, 619 insertions(+), 452 deletions(-)
 delete mode 100644 drivers/edac/amd64_edac_err_types.c
 create mode 100644 drivers/edac/edac_mce_amd.c
 create mode 100644 drivers/edac/edac_mce_amd.h

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

