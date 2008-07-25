Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbYGYOtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYGYOtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYGYOtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:49:11 -0400
Received: from mail-va3.bigfish.com ([216.32.180.113]:61353 "EHLO
	mail134-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751555AbYGYOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:49:10 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j)
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K4KH5K-04-22U-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] x86 cleanup: convert round_up() to roundup()
Date: Fri, 25 Jul 2008 16:48:54 +0200
Message-Id: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 25 Jul 2008 14:48:59.0394 (UTC) FILETIME=[9250DE20:01C8EE65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 architecture declares its own round_up macro. But there is a generic
one in <linux/kernel.h> which can also be used. This patchset replaces the x86
round_up() macro with the generic roundup() one where possible.
The patches have been compile-tested for 32 and 64 bit and boot-tested for 64
bit.
If we can fix the other places too we can get rid of the x86 specific
round_up() in the future.

diffstat:

 arch/x86/kernel/pci-dma.c  |    2 +-
 arch/x86/mm/discontig_32.c |    2 +-
 arch/x86/mm/init_64.c      |    8 ++++----
 arch/x86/mm/numa_64.c      |   10 +++++-----
 arch/x86/mm/pageattr.c     |    2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)



