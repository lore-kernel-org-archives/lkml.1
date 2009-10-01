Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbZJAHbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbZJAHbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbZJAHbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:31:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49438 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755625AbZJAHbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:31:51 -0400
Date: Thu, 1 Oct 2009 09:31:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] optimize for perf_event_init_task()
Message-ID: <20091001073138.GB1502@elte.hu>
References: <4AB88F06.10900@cn.fujitsu.com> <19128.39768.149110.673711@cargo.ozlabs.ibm.com> <4AB98BB0.6020202@cn.fujitsu.com> <19129.38627.94363.857137@cargo.ozlabs.ibm.com> <4AB9D7FA.5040707@cn.fujitsu.com> <1253695230.7695.122.camel@twins> <4ABC5A55.7000208@cn.fujitsu.com> <4ABC5AF9.6060808@cn.fujitsu.com> <1253868957.10287.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253868957.10287.5.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0761]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-09-25 at 13:54 +0800, Xiao Guangrong wrote:
> > We can traverse ctx->group_list to get all group leader, it should be safe
> > since we hold ctx->mutex
> > 
> > Changlog v1->v2:
> > - remove WARN_ON_ONCE() as Peter Zijlstra's suggestion
> > 
> > Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> 
> Thanks!
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks Xiao and Peter, i've queued up both patches for v2.6.32.

	Ingo
