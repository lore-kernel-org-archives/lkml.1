Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbYFTTz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbYFTTz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYFTTzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:55:21 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:17038 "EHLO
	mail51-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYFTTzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:55:20 -0400
X-BigFish: VPS-1(zz4015Mzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K2S1ZN-01-86C-01
Date: Fri, 20 Jun 2008 21:55:03 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 0/7] x86: pat.c: reserve_memtype strip down
Message-ID: <20080620195503.GB4105@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Jun 2008 19:55:06.0415 (UTC) FILETIME=[89749BF0:01C8D30F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set will (first of all) cleanup reserve_memtype a little
bit to make it easier to read and maintain.

(... and hopefully it doesn't break anything.;-)

Overall diffstat is

 arch/x86/mm/ioremap.c  |    2 
 arch/x86/mm/pat.c      |  263 ++++++++++++++++---------------------------------
 include/asm-x86/e820.h |    1 
 3 files changed, 93 insertions(+), 173 deletions(-)

Instead of sending one large patch I broke it down into several pieces
to make it easier to review.

Patches are against today's tip/x86/pat (v2.6.26-rc6-107-gdd0c7c4).
Please apply.


Thanks,

Andreas


