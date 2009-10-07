Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbZJGPJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbZJGPJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbZJGPJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:09:11 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:56376
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754284AbZJGPJJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:09:09 -0400
X-SpamScore: -12
X-BigFish: VPS-12(z21eWzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KR5GPU-03-25M-02
X-M-MSG: 
Date: Wed, 7 Oct 2009 17:08:53 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: x86 <x86@kernel.org>, Doug Thompson <norsk5@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD64 EDAC fixes for 2.6.32-rc4
Message-ID: <20091007150853.GB29473@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 Oct 2009 15:08:16.0039 (UTC) FILETIME=[FF132370:01CA475F]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

As it is obvious from the commit messages below, those are strictly
driver fixes. Please pull.

Thanks.

The following changes since commit 0eca52a92735f43462165efe00a7e394345fb38e:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (7):
      amd64_edac: fix driver instance lookup table allocation
      amd64_edac: fix DRAM base and limit address extraction
      amd64_edac: fix interleave enable tests
      amd64_edac: fix K8 intlv_sel check
      amd64_edac: fix chip select handling
      amd64_edac: fix DRAM base and limit extraction
      amd64_edac: beef up DRAM error injection

Keith Mannthey (1):
      amd64_edac: simple fix to allow reporting of CECC errors

 drivers/edac/amd64_edac.c     |  104 +++++++++++++++++++----------------------
 drivers/edac/amd64_edac.h     |   23 ++++-----
 drivers/edac/amd64_edac_inj.c |   49 +++++++++++++++++--
 3 files changed, 101 insertions(+), 75 deletions(-)

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

