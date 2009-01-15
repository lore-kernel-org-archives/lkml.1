Return-Path: <linux-kernel-owner+w=401wt.eu-S1762765AbZAOKWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762765AbZAOKWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZAOKW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:22:29 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54241 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbZAOKW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:22:28 -0500
Date: Thu, 15 Jan 2009 19:21:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 0/4] cgroup/memcg : updates related to CSS
Message-Id: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm sorry that I couldn't work so much, this week.
No much updates but I think all comments I got are applied.

About memcg part, I'll wait for that all Nishimura's fixes go ahead.
If cgroup part looks good, please Ack. I added CC to Andrew Morton for that part.

changes from previous series
  - dropeed a fix to OOM KILL   (will reschedule)
  - dropped a fix to -EBUSY     (will reschedule)
  - added css_is_populated()
  - added hierarchy_stat patch

Known my homework is
  - resize_limit should return -EBUSY. (Li Zefan reported.)

Andrew, I'll CC: you [1/4] and [2/4]. But no explicit Acked-by yet to any patches.


Thanks,
-Kame

