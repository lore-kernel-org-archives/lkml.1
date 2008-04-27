Return-Path: <linux-kernel-owner+w=401wt.eu-S1759832AbYD0XQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbYD0XQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763195AbYD0XQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:16:06 -0400
Received: from smtp04.mtu.ru ([62.5.255.51]:62976 "EHLO smtp04.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759864AbYD0XQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:16:03 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: x86: fix a couple of sparse warnings
Date: Mon, 28 Apr 2008 03:15:57 +0400
Message-Id: <1209338159-30095-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
X-DCC-STREAM-Metrics: smtp04.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Peter, Thomas,

Here is a couple of patches that fix sparse warnings
produced while compiling defconfig for i386:

<<<<<

arch/x86/kernel/reboot.c:32:5: warning: symbol 'reboot_force' was not declared. Should it be static?

arch/x86/kernel/pci-dma.c:17:5: warning: symbol 'iommu_sac_force' was not declared. Should it be static?

<<<<<

These patches were compile-tested using defconfig for both
i386 and x86_64. Also, a runtime test was successfully
performed by booting i386 and x86_64 boxes up to the shell
prompt.

Patches apply cleanly to current x86.git.

Please consider.

Thanks,
Dmitri Vorobiev
