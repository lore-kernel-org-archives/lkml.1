Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbZKYVjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbZKYVjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759380AbZKYVjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:39:07 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58036 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759147AbZKYVjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:39:05 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] Blackfin fixes for 2.6.32
Date: Wed, 25 Nov 2009 16:38:59 -0500
Message-Id: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignoring the updated anomaly lists, we've got a whole bunch of tiny
fixes either for regressions and hardware anomalies.

André Goddard Rosa (1):
  Blackfin: fix cache Kconfig typo

Graf Yang (1):
  Blackfin: fix SMP build error in start_thread()

Jie Zhang (1):
  Blackfin: fix typo in ptrace poking

Michael Hennerich (1):
  Blackfin: fix suspend/resume failure with some on-chip ROMs

Mike Frysinger (3):
  Blackfin: update anomaly lists
  Blackfin: work around testset anomaly 05000477
  Blackfin: check for anomaly 05000475

Roel Kluin (1):
  Blackfin: fix memset in smp_send_reschedule() and -stop()

 arch/blackfin/kernel/bfin_dma_5xx.c             |    9 ++++++-
 arch/blackfin/kernel/cplb-mpu/cplbinit.c        |    2 +-
 arch/blackfin/kernel/process.c                  |    2 +-
 arch/blackfin/kernel/ptrace.c                   |    2 +-
 arch/blackfin/mach-bf518/include/mach/anomaly.h |   18 ++++++++++++---
 arch/blackfin/mach-bf527/include/mach/anomaly.h |   20 +++++++++++++----
 arch/blackfin/mach-bf533/include/mach/anomaly.h |   18 ++++++++++++---
 arch/blackfin/mach-bf537/include/mach/anomaly.h |   18 ++++++++++++---
 arch/blackfin/mach-bf538/include/mach/anomaly.h |   18 ++++++++++++---
 arch/blackfin/mach-bf548/include/mach/anomaly.h |   23 ++++++++++++++++----
 arch/blackfin/mach-bf561/atomic.S               |   14 +++++++++++-
 arch/blackfin/mach-bf561/include/mach/anomaly.h |   25 ++++++++++++++++++----
 arch/blackfin/mach-common/arch_checks.c         |    5 ++++
 arch/blackfin/mach-common/smp.c                 |    6 +---
 14 files changed, 138 insertions(+), 42 deletions(-)

