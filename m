Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbZDNQFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbZDNQFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbZDNQFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:05:16 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:32883 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbZDNQFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:05:14 -0400
Date: Tue, 14 Apr 2009 21:34:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [BUGFIX][PATCH]  memcg: use rcu_dereference to access mm->owner
Message-ID: <20090414160429.GP7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090413154343.b12e9711.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090413154343.b12e9711.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-13 15:43:43]:

> the patch itself is against mmotm-Apr11.
> Maybe it's better to apply 2.6.30-rc series.
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> mm->owner should be accessed with rcu_dereference().
> 
> Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
