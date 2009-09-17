Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZIQCnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZIQCnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbZIQCnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:43:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51535 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbZIQCnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:43:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 17 Sep 2009 11:41:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Am?rico_Wang <xiyou.wangcong@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/3][mmotm] showing size of kcore  (Was Re: kcore patches
 (was Re: 2.6.32 -mm merge plans)
Message-Id: <20090917114138.e14a1183.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
References: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
	<1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 20:17:52 +0900 (JST)
"KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> But for now, we have to use some fixed value....and using above
> patch for 2.6.31 is not very bad.
> 

This set is based on mmotm's kcore patch stack.
So, just for discussing. 

  [1/3] ... clean up (tiny bug fix)
  [2/3] ... show size of /proc/kcore
  [3/3] ... update kcore size at memory hotplug.

After patches, /proc/kcore's size is as following.
==
[kamezawa@bluextal mmotm-2.6.31-Sep14]$ ls -l /proc/kcore
-r-------- 1 root root 140737486266368 2009-09-17 11:53 /proc/kcore
[kamezawa@bluextal mmotm-2.6.31-Sep14]$
==
I'm not sure how this value is useful...but..hmm..better than zero ?
(The reason of very big value is because vmalloc area is too large.)


Thanks,
-Kame

