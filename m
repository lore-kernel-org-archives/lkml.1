Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbYAOFtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbYAOFtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 00:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYAOFtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 00:49:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:52482 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbYAOFtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 00:49:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,285,1196668800"; 
   d="scan'208";a="324613242"
Subject: [PATCH -mm 0/3] i386 boot: replace boot_ioremap with enhanced
	bt_ioremap
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Jan 2008 13:45:02 +0800
Message-Id: <1200375902.3505.29.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 15 Jan 2008 05:44:47.0483 (UTC) FILETIME=[BCF2A4B0:01C85739]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset replaces boot_ioremap with a enhanced version of
bt_ioremap and renames the bt_ioremap to early_ioremap. This reduces
12k from .init.data segment and increases the size of memory that can
be re-mapped before paging_init to 64k.

This patchset is based on linux-2.6.24-rc5-mm1 +
efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code.patch.
It has been tested on i386 with PAE on/off.

Best Regards,
Huang Ying

