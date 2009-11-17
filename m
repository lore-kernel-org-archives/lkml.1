Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbZKQWLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbZKQWLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbZKQWLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:11:11 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:3975 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbZKQWLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:11:09 -0500
Subject: [PATCH 0/3] cpufreq / linux-next build fixes
To: davej@redhat.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Date: Tue, 17 Nov 2009 15:11:15 -0700
Message-ID: <20091117220729.25933.57884.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

I tripped over a build error when building /without/ CONFIG_CPU_FREQ.

I found this by way of the mmotm tree which I think sucks in linux-next.
I haven't checked your cpufreq tree directly, so apologies if these are
already fixed...

I build tested my changes with both CONFIG_CPU_FREQ set and unset, and
looked at the sparse output too, and all seems to be well. I did not
run-time test these changes.

Thanks,
/ac

---

Alex Chiang (3):
      [CPUFREQ] make ACPI P-state cpufreq drivers depend on CONFIG_CPU_FREQ
      ACPI: do not define acpi_processor_get_bios_limit() in processor.h
      [CPUFREQ] make internal cpufreq_add_dev_* static


 arch/x86/kernel/cpu/cpufreq/Kconfig |    6 +++---
 drivers/cpufreq/cpufreq.c           |    6 +++---
 include/acpi/processor.h            |    5 -----
 3 files changed, 6 insertions(+), 11 deletions(-)

