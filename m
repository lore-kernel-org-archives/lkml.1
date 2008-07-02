Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbYGBVSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbYGBVSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbYGBVSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:18:14 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:45203 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbYGBVSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:18:12 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3EDTS-01-1WR-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 0/11] x86/pci 32/64 bit merge
Date: Wed, 2 Jul 2008 22:50:18 +0200
Message-ID: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 02 Jul 2008 21:17:55.0709 (UTC) FILETIME=[1857B2D0:01C8DC89]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series merges the x86/pci code. It's relative to
tip/x86/cpu since there are already changes that touch pci code.

I reworked parts of the subsys_initcalls to remove Makefile object
order dependencies. The kernel reboots for acpi/noacpi, smp/nosmp,
32/64 bit. It compiles for numaq and visws (I don't have hardware
available for this configurations, so please test these configs if you
have hardware available).

There is still some work to do in arch/x86/pci/amd_bus.c and for
mmconfig.

Signed-off-by: Robert Richter <robert.richter@amd.com>



