Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbZHJC6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbZHJC6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 22:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZHJC6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 22:58:34 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37843 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZHJC6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 22:58:34 -0400
Date: Mon, 10 Aug 2009 11:23:26 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH 0/2] mm: some patches about add_to_swap_cache()
Message-Id: <20090810112326.3526b11d.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches about add_to_swap_cache(), related to
the commit 355cfa73(mm: modify swap_map and add SWAP_HAS_CACHE flag).

[BUGFIX][1/2] mm: add_to_swap_cache() must not sleep
[cleanup][2/2] mm: add_to_swap_cache() does not return -EEXIST

These are based on 2.6.31-rc5, but can be applied onto mmotm.
Any comments or suggestions would be welcome.

Thanks,
Daisuke Nishimura.
