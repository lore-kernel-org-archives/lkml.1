Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYJAHp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYJAHp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbYJAHpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:45:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47985 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYJAHpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:45:51 -0400
Date: Wed, 1 Oct 2008 16:52:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH 0/6] memcg update v6 (for review and discuss)
Message-Id: <20081001165233.404c8b9c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is update from v5.

easy 4 patches are already posted as ready-to-go-series.

This is need-more-discuss set.

Includes following 6 patches. (reduced from v5).
The whole series are reordered.

[1/6] make page_cgroup->flags to be atomic.
[2/6] allocate all page_cgroup at boot.
[3/6] rewrite charge path by charge/commit/cancel
[4/6] new force_empty and move_account
[5/6] lazy lru free
[6/6] lazy lru add.

Patch [3/6] and [4/6] are totally rewritten.
Races in Patch [6/6] is fixed....I think.

Patch [1-4] seems to be big but there is no complicated ops.
Patch [5-6] is more racy. Check-by-regression-test is necessary.
(Of course, I does some.)

If ready-to-go-series goes, next is patch 1 and 2.

Thanks,
-Kame

