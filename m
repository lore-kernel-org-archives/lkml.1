Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYLKDYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYLKDYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 22:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbYLKDYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 22:24:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33783 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbYLKDYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 22:24:10 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] memcg: show real limit under hierarchy
Cc: kosaki.motohiro@jp.fujitsu.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20081211121135.e00f6a2d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081211121135.e00f6a2d.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20081211122237.4FF7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 11 Dec 2008 12:24:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I wonder other people who debugs memcg's hierarchy may use similar patches.
> this is my one.
> comments ?
> ==
> From:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Show "real" limit of memcg.
> This helps my debugging and maybe useful for users.
> 
> While testing hierarchy like this
> 
> 	mount -t cgroup none /cgroup -t memory
> 	mkdir /cgroup/A
> 	set use_hierarchy==1 to "A"
> 	mkdir /cgroup/A/01
> 	mkdir /cgroup/A/01/02
> 	mkdir /cgroup/A/01/03
> 	mkdir /cgroup/A/01/03/04
> 	mkdir /cgroup/A/08
> 	mkdir /cgroup/A/08/01
> 	....
> and set each own limit to them, "real" limit of each memcg is unclear.
> This patch shows real limit by checking all ancestors in memory.stat.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Great!

I hoped to use this patch at hierarchy inactive_ratio debugging ;)



