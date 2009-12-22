Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbZLVLll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbZLVLll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZLVLlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:41:40 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:58693
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751653AbZLVLlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:41:39 -0500
X-SpamScore: 7
X-BigFish: VPS7(z37d4lzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KV1XT5-02-GEC-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: AMD64 EDAC fixlets for .33
Date: Tue, 22 Dec 2009 12:41:11 +0100
Message-ID: <1261482077-23733-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.5.4
X-OriginalArrivalTime: 22 Dec 2009 11:41:30.0504 (UTC) FILETIME=[B431B880:01CA82FB]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are a bunch of fixes to several edac buglets and annoyances I've
been meaning to fix but never got around to it, alongside two fixes of
reported problems. They are pretty small and straightforward and I'll
push them to Linus later if there are no objections. Series tested on
your garden variety of K8 and F10h Opterons found around the office.

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

