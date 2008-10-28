Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYJ1GcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYJ1GcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 02:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYJ1Gby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 02:31:54 -0400
Received: from mga10.intel.com ([192.55.52.92]:24359 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752247AbYJ1Gbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 02:31:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,497,1220252400"; 
   d="scan'208";a="632327421"
Subject: cpu2000(both float and int) 13% regression with 2.6.28-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 Oct 2008 14:32:02 +0800
Message-Id: <1225175522.1685.57.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.27, cpu2000 (both float and int) has about 13% regression
with 2.6.28-rc1 ﻿on my new-model x86-64 machine.

I bisected down to below patch.

commit 0afe2db21394820d32646a695eccf3fbfe6ab5c7
Merge: d847059... 43603c8...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sat Oct 11 20:23:20 2008 +0200

    Merge branch 'x86/unify-cpu-detect' into x86-v28-for-linus-phase4-D
    
    Conflicts:
        arch/x86/kernel/cpu/common.c
        arch/x86/kernel/signal_64.c
        include/asm-x86/cpufeature.h


When I tried to revert it against 2.6.28-rc2, there are many conflictions.

Ingo,
Is it possible to break it to small patches, so we can locate the bad source lines?

Yanmin


