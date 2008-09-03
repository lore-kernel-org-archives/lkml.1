Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYICNiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYICNiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYICNiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:38:10 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:46631 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYICNiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:38:09 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="18324066"
Message-ID: <48BE912F.7090809@citrix.com>
Date: Wed, 03 Sep 2008 14:29:19 +0100
From: Alex Nixon <alex.nixon@citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/3] Fix Xen cpu hotplug build
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2008 13:28:17.0855 (UTC) FILETIME=[ED0EA4F0:01C90DC8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains various build fixes against the Xen cpu hotplug series currently in tip/x86/xen

Diff stats:

 arch/x86/kernel/cpu/common.c |    7 -------
 arch/x86/kernel/process_32.c |    7 +++++++
 arch/x86/kernel/process_64.c |    7 +++++++
 arch/x86/kernel/tlb_32.c     |    8 ++++++++
 drivers/xen/Makefile         |    3 ++-
 drivers/xen/cpu_hotplug.c    |    2 +-
 include/asm-x86/smp.h        |    9 ---------
 include/asm-x86/tlbflush.h   |   10 ++++++++++
 8 files changed, 35 insertions(+), 18 deletions(-)
