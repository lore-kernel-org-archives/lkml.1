Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbZJGJl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbZJGJl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 05:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbZJGJl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 05:41:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44286 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371AbZJGJl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 05:41:56 -0400
Date: Wed, 7 Oct 2009 11:41:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_event: Remove include/linux/perf_counter.h
Message-ID: <20091007094108.GA26272@elte.hu>
References: <4ACC5F6D.7020809@cn.fujitsu.com> <1254908212.26976.229.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254908212.26976.229.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0484]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-10-07 at 17:29 +0800, Xiao Guangrong wrote:
> > Remove include/linux/perf_counter.h because it's not used anymore after
> > one of Ingo's patch:
> 
> The intent was to keep it around for one more release so as to not 
> inconvenience userspace that relied on it too much, ie. give them time 
> to convert.

yeah. There's no real cost in keeping it around. We can remove it in .34 
or .35.

	Ingo
