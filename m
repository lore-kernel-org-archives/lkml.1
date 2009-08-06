Return-Path: <linux-kernel-owner+w=401wt.eu-S1751752AbZHFK0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbZHFK0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZHFK0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:26:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59408 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZHFK0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:26:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 6 Aug 2009 19:24:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: xiyou.wangcong@gmail.com, akpm@linux-foundation.org
Subject: [PATCH 0/6] kcore clean up and enhance
Message-Id: <20090806192416.4f94be76.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set is for /proc/kcore. By this,

 - many per-arch hooks are removed.

 - /proc/kcore will know really valid physical memory area.

 - /proc/kcore will be aware of memory hotplug.

 - /proc/kcore will be architecture independent i.e.
   if an arch supports CONFIG_MMU, it can use /proc/kcore.
   (if the arch uses usual memory layout.)

BTW, I'll be on small trip from Aug/11 to Aug/17. So, my rtt may be
bad in the next week.

Thanks,
-Kame

