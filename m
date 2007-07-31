Return-Path: <linux-kernel-owner+w=401wt.eu-S940834AbXGaCfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940834AbXGaCfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764693AbXGaCeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:34:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53861 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763743AbXGaCes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:34:48 -0400
Date: Tue, 31 Jul 2007 11:35:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "Zoltan.Menyhart@bull.net" <Zoltan.Menyhart@bull.net>,
       Christoph Lameter <clameter@sgi.com>,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] flush icache before set_pte take6. [0/4]
Message-Id: <20070731113543.93ffd964.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

flush icache before set_pte() for ia64 patch set.

patches are against 2.6.23-rc1.

Changes:
  - Added "Is Montecito?" check for optimization.

Thanks,
-Kame

