Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbYFEAvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbYFEAvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 20:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYFEAvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 20:51:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52603 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYFEAvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 20:51:12 -0400
Date: Thu, 05 Jun 2008 09:50:48 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH 1/4] per-task-delay-accounting: add memory reclaim delay
Cc: kosaki.motohiro@jp.fujitsu.com,
       Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <4846D632.4030803@ct.jp.nec.com>
References: <20080604115917.9408.KOSAKI.MOTOHIRO@jp.fujitsu.com> <4846D632.4030803@ct.jp.nec.com>
Message-Id: <20080605092451.9C1D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +	delayacct_freepages_start();
> >>  	did_some_progress = try_to_free_pages(zonelist, order, gfp_mask);
> >> +	delayacct_freepages_end();
> > 
> > Shouldn't we consider memcgroup reclaim?
> 
> thanks for pointing this.
> Unfortunately, we're not so familiar to memcgroup.
> Will look into this.
> Could you tell us pointers to memcgroup?

Documentation/controllers/memory.txt is good guide :)

<abstract>
try_to_free_pages():	         global reclaim entry point
try_to_free_mem_cgroup_pages():  memcgroup reclaim entry point
do_try_to_free_pages():	         common layer


Unfortunately, I don't know your requirement and
memcgroup reclaim shold be mesured.
I hope you explain your purpose and benefit more.

Thanks.

