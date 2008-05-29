Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYE2W3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYE2W3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbYE2W2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:28:54 -0400
Received: from main.gmane.org ([80.91.229.2]:49785 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbYE2W2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:28:53 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: [X86] Watchdog lockdep warning with next-20080529
Date: Thu, 29 May 2008 23:25:53 +0100
Message-ID: <g1namq$qk5$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Cc: kernel-testers@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<posted & mailed>

While using linux-next-20080529 the following warning was printed:

[ 1108.103357] ------------[ cut here ]------------
[ 1108.103370] WARNING: at kernel/lockdep.c:2680 check_flags+0x8a/0x12d()
[ 1108.103377] Modules linked in:
[ 1108.103384] Pid: 5, comm: watchdog/0 Not tainted
2.6.26-rc4-next-20080529skw #134
[ 1108.103392]  [<c0122f80>] warn_on_slowpath+0x41/0x6a
[ 1108.103402]  [<c013cc30>] ? trace_hardirqs_off+0xb/0xd
[ 1108.103411]  [<c013ea60>] ? trace_hardirqs_on+0xb/0xd
[ 1108.103419]  [<c013ea19>] ? trace_hardirqs_on_caller+0xe8/0x124
[ 1108.103428]  [<c013ea60>] ? trace_hardirqs_on+0xb/0xd
[ 1108.103436]  [<c011d428>] ? hrtick_set+0xce/0xd6
[ 1108.103445]  [<c013c87e>] check_flags+0x8a/0x12d
[ 1108.103452]  [<c013f9a0>] lock_acquire+0x3b/0x89
[ 1108.103459]  [<c0361ada>] _read_lock+0x1c/0x49
[ 1108.103467]  [<c01538b2>] ? watchdog+0x97/0x1a9
[ 1108.103475]  [<c015381b>] ? watchdog+0x0/0x1a9
[ 1108.103483]  [<c01538b2>] watchdog+0x97/0x1a9
[ 1108.103489]  [<c015381b>] ? watchdog+0x0/0x1a9
[ 1108.103497]  [<c0133044>] kthread+0x3b/0x63
[ 1108.103504]  [<c0133009>] ? kthread+0x0/0x63
[ 1108.103512]  [<c01038ab>] kernel_thread_helper+0x7/0x10
[ 1108.103520]  =======================
[ 1108.103525] ---[ end trace bf12fd91b8f59e65 ]---
[ 1108.103529] possible reason: unannotated irqs-on.
[ 1108.103534] irq event stamp: 18
[ 1108.103538] hardirqs last  enabled at (17): [<c013ea60>]
trace_hardirqs_on+0xb/0xd
[ 1108.103548] hardirqs last disabled at (18): [<c013cc30>]
trace_hardirqs_off+0xb/0xd
[ 1108.103558] softirqs last  enabled at (0): [<c01216ab>]
copy_process+0x2dd/0xf9a
[ 1108.103568] softirqs last disabled at (0): [<00000000>] 0x0

-- 
Sitsofe | http://sucs.org/~sits/

