Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbZCAHOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbZCAHOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 02:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZCAHO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 02:14:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:53080 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbZCAHO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 02:14:28 -0500
Message-ID: <49AA35AF.8030302@kernel.org>
Date: Sun, 01 Mar 2009 16:13:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH tj-percpu 2/3] alpha: fix typo in recent early vmalloc change
References: <49AA357C.3070006@kernel.org>
In-Reply-To: <49AA357C.3070006@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 01 Mar 2009 07:13:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix build

Add missing 'o' in variable name.  Compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index 91eddd8..af71d38 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -202,7 +202,7 @@ callback_init(void * kernel_end)
 		console_remap_vm.size = nr_pages << PAGE_SHIFT;
 		vm_area_register_early(&console_remap_vm, PAGE_SIZE);
 
-		vaddr = (unsigned long)consle_remap_vm.addr;
+		vaddr = (unsigned long)console_remap_vm.addr;
 
 		/* Set up the third level PTEs and update the virtual
 		   addresses of the CRB entries.  */
-- 
1.6.0.2

