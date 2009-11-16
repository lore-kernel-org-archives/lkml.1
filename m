Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbZKPORS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbZKPORS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZKPORP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:17:15 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:16507 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbZKPOQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:38 -0500
X-SpamScore: -2
X-BigFish: VPS-2(z37d4lz14ffOzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KT7GYY-02-PYQ-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 00/21] amd64_edac queue for .33
Date: Mon, 16 Nov 2009 15:16:27 +0100
Message-ID: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
X-OriginalArrivalTime: 16 Nov 2009 14:16:12.0360 (UTC) FILETIME=[59BD8C80:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here is the current patchqueue of amd64_edac fixes/improvements for the
next merge window, among which are a faster syndrome decoding algorithm,
DDR3 support, important fixes and a large amount of cleanups.


01,02,05,06,07,08,09,10,12,13,14,16,21:

cleanups/simplifications/code unification/debug enhancements/speedups

03:

this one is in -tip, listed for the sake of completenes here

04:

final cpumask_t -> struct cpumask conversion bits

11,17,18:

DDR3 support

15:

F10h revD fix

19:

much faster and leaner x4/x8 syndrome decoding

20:

important fix since syndrome to channel decoding should be done only
when in ganged mode.

The patches are also at

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-next

for those who would like to give them a run.

arch/x86/include/asm/msr.h  |    4 +-
 arch/x86/lib/msr.c          |   46 +-
 drivers/edac/amd64_edac.c   | 1251 +++++++++++++++++++------------------------
 drivers/edac/amd64_edac.h   |   62 ++-
 drivers/edac/edac_core.h    |    1 +
 drivers/edac/edac_mc.c      |   24 +
 drivers/edac/edac_mce_amd.c |    2 +-
 7 files changed, 642 insertions(+), 748 deletions(-)


-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center

