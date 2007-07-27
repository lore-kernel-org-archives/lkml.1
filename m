Return-Path: <linux-kernel-owner+w=401wt.eu-S935207AbXG0Egg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935207AbXG0Egg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 00:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbXG0EgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 00:36:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56124 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbXG0EgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 00:36:05 -0400
Date: Fri, 27 Jul 2007 13:36:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       Zoltan.Menyhart@bull.net, Christoph Lameter <clameter@sgi.com>,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] flush cache fixes for ia64 [0/2] intro
Message-Id: <20070727133657.8c9c6803.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is flush_cache_xxx fixes for ia64, take4.
against 2.6.23-rc1.

Consists of 2 patches.

1. page migration fix         ... Christoph, could you review this ?

2. remove lazy_mmu_prot_update() and introduce sync_icache_dcache() 
   If name or style is wrong, please point out.

Any comments are welcome.

Thanks,
-Kame

