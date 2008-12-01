Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbYLAKBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbYLAKBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 05:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYLAKBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 05:01:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42808 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbYLAKBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 05:01:15 -0500
Date: Mon, 1 Dec 2008 19:00:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       hugh@veritas.com, nickpiggin@yahoo.com.au, knikanth@suse.de,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 0/4] memcg: unified easy patch series for mmotm-Nov30
Message-Id: <20081201190021.f3ab1f17.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series are fixed and clean-up agasist
 "mm-of-the-moment snapshot 2008-11-30-22-35"

Picked up useful ones from recent linux-mm.
patches are numbered but I think each can be applied one by one independently.

[1/4] clean up move_tasks of memcg.
	(From Nikanth Karthikesan <knikanth@suse.de>)
	Obvious change.

[2/4] fixes mem+swap controller's limit check
	(From Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>)
	Maybe Ack from Balbir is appropriate.

[3/4] clean up gfp_mask passed to memcg.
	From me. I want a review by Hugh Dickins and Nick Piggin. please.

[4/4] fix the name of scan_global_lru().
	From me. Obvious change.

I'll queue Kosaki's memcg LRU fixes and cgroup-ID based on this.

Thanks,
-Kame

