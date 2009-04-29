Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbZD2Qz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbZD2Qz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755685AbZD2QzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:55:25 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:34018
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754859AbZD2QzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:55:24 -0400
X-BigFish: VPS-8(zz1528M4015Lzz1202hzzz32i)
X-WSS-ID: 0KIVGBV-02-4OX-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com
CC: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <dougthompson@xmission.com>, <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Doug Thompson <dougthompson@xmission.com>
Subject: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
Date: Wed, 29 Apr 2009 18:54:46 +0200
Message-ID: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
X-OriginalArrivalTime: 29 Apr 2009 16:55:12.0882 (UTC) FILETIME=[434DED20:01C9C8EB]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks to all reviewers of the previous submission, here is the second
version of this series.

Highlights are the addition of two helpers to read/write MSRs on several
CPUs, denoted by a cpumask and using an array of MSR values per-CPU, as
Peter suggested. Since IMHO they look generic enough I've added them to
arch/x86/lib/msr-on-cpu.c (now renamed to msr.c).

Moreover, I've addressed all the issues raised from the previous series.
Please let me know should there be anything else remaining.

Thanks,
Boris.

 arch/x86/include/asm/msr.h |   11 +
 arch/x86/lib/Makefile      |    2 +-
 arch/x86/lib/msr-on-cpu.c  |   97 -
 arch/x86/lib/msr.c         |  151 ++
 drivers/edac/Kconfig       |   26 +
 drivers/edac/Makefile      |    1 +
 drivers/edac/amd64_edac.c  | 5385 ++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 5575 insertions(+), 98 deletions(-)

