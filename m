Return-Path: <linux-kernel-owner+w=401wt.eu-S1764813AbXJRDVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764813AbXJRDVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761057AbXJRDVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:21:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55683 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbXJRDVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:21:21 -0400
Date: Thu, 18 Oct 2007 12:20:38 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@osdl.org>
Subject: [Patch 000/002](memory hotplug) Rearrange notifier of memory hotplug (take 2)
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071018120343.5146.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This patch set is to rearrange event notifier for memory hotplug,
because the old notifier has some defects. For example, there is no
information like new memory's pfn and # of pages for callback functions.

Fortunately, nothing uses this notifier so far, there is no impact by
this change. (SLUB will use this after this patch set to make
kmem_cache_node structure).

In addition, descriptions of notifer is added to memory hotplug
document.

This patch was a part of patch set to make kmem_cache_node of SLUB 
to avoid panic of memory online. But, I think this change becomes
not only for SLUB but also for others. So, I extracted this from it.

This patch set is for 2.6.23-mm1.
I tested this patch on my ia64 box.

Please apply.

Bye.

-- 
Yasunori Goto 


