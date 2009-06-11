Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbZFKH5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbZFKH5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 03:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbZFKH5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 03:57:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36348 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZFKH5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 03:57:12 -0400
Date: Thu, 11 Jun 2009 16:55:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       apw@canonical.com, riel@redhat.com, minchan.kim@gmail.com,
       mel@csn.ul.ie
Subject: [PATCH 0/3] misc fix around vmscan/isolate_lru_pages
Message-Id: <20090611165535.cf46bf29.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you for all helps. I finally wrote 3 small pathces.

All 3 patches are for vmscan.c::isolate_lru_pages().

[1/3] ... remove unnecessary/wrong lru rotation in lumpy reclaim.
[2/3] ... check PG_unevictable at lumpy reclaim
[3/3] ... fix memcg's lru rotation logic.

All 3 are just for fixes and don't do any other.
I'll revisit this area while working for memcg.

Thanks,
-Kame

