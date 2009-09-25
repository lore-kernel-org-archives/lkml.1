Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZIYIzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZIYIzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbZIYIzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:55:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZIYIzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:55:16 -0400
Subject: Re: [PATCH 2/2 v2] optimize for perf_event_init_task()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4ABC5AF9.6060808@cn.fujitsu.com>
References: <4AB88F06.10900@cn.fujitsu.com>
	 <19128.39768.149110.673711@cargo.ozlabs.ibm.com>
	 <4AB98BB0.6020202@cn.fujitsu.com>
	 <19129.38627.94363.857137@cargo.ozlabs.ibm.com>
	 <4AB9D7FA.5040707@cn.fujitsu.com> <1253695230.7695.122.camel@twins>
	 <4ABC5A55.7000208@cn.fujitsu.com>  <4ABC5AF9.6060808@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Sep 2009 10:55:57 +0200
Message-Id: <1253868957.10287.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 13:54 +0800, Xiao Guangrong wrote:
> We can traverse ctx->group_list to get all group leader, it should be safe
> since we hold ctx->mutex
> 
> Changlog v1->v2:
> - remove WARN_ON_ONCE() as Peter Zijlstra's suggestion
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Thanks!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
