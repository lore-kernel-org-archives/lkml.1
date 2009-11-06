Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbZKFIzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbZKFIzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZKFIzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:55:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49138 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbZKFIzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:55:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 6 Nov 2009 17:52:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 0/2] memcg make use of new percpu implementations
Message-Id: <20091106175242.6e13ee29.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recent updates on dynamic percpu allocation looks good and I tries to rewrite
memcg's poor implementation of percpu status counter.
(It's not NUMA-aware ...)
Thanks for great works.

For this time. I added Christoph to CC because I'm not fully sure my usage of
__this_cpu_xxx is correct...I'm glad if you check the usage when you have time.


Patch 1/2 is just clean up (prepare for patch 2/2)
Patch 2/2 is for percpu.

Tested on my 8cpu box and works well.
Pathcesa are against the latest mmotm.

Thanks,
-Kame

