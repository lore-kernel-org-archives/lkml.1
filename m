Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbYGJRBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbYGJRBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbYGJRBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:01:03 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:42996 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYGJRBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:01:02 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3SV99-02-GG6-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] x86/pci: patches for tip/x86/unify-pci
Date: Thu, 10 Jul 2008 18:58:21 +0200
Message-ID: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 10 Jul 2008 17:00:50.0602 (UTC) FILETIME=[819128A0:01C8E2AE]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains patches for tip/x86/unify-pci. It fixes
NUMA initialization code reflecting latest changes in tip/master. Also
there are build fixes and minor cleanups. Patch #5 is a cherry pick
that fixes build on UP systems. Code reboots for smp/nosmp,
acpi/noacpi, numaq, 32/64bit. It compiles for visws.



