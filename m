Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbXG1GCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbXG1GCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 02:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbXG1GB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 02:01:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46543 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbXG1GB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 02:01:58 -0400
Date: Sat, 28 Jul 2007 15:03:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>, Zoltan.Menyhart@bull.net,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH] flush icache before set_pte() take 5.
Message-Id: <20070728150319.d19f531f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Appliled comments on take 4.
patches are against 2.6.23-rc1.

Changes:
  - changes flush_icache_page to be flush_cache_page() in remove_migration_pte().
  - removed sync_icache_dcahe() in page reuse case of do_wp_page(). 

Considerations:
  - I can add CONFIG_MONTECITO if necessary. But it will be confusing, I think.

Thanks,
-Kame

