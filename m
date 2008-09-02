Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbYIBLOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbYIBLOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 07:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYIBLOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 07:14:04 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:55040 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYIBLOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 07:14:03 -0400
X-BigFish: VPS2(zba6iz3117Kzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K6KF6T-04-A5O-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org
Subject: x86: add northbridge detection for AMD family 0x11 cpus
Date: Tue, 2 Sep 2008 13:13:38 +0200
Message-ID: <1220354020-4883-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 02 Sep 2008 11:13:40.0630 (UTC) FILETIME=[F43E2B60:01C90CEC]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this small patch series adds PCI device ids for the northbridge in AMD family
0x11 processors and adds the ids to the detection code. With this patches the
GART in these processors is found by the kernel.

Regards,

Joerg

git diff --stat tip/master.. :

 arch/x86/kernel/k8.c    |    5 +++--
 include/linux/pci_ids.h |    5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)



