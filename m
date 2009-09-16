Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbZIPSuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbZIPSuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbZIPSuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:50:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbZIPSuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:50:11 -0400
Subject: Re: [tip:sched/core] sched: Disable wakeup balancing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-182a85f8a119c789610a9d464f4129ded9f3c107@git.kernel.org>
References: <new-submission>
	 <tip-182a85f8a119c789610a9d464f4129ded9f3c107@git.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 20:50:00 +0200
Message-Id: <1253127000.7166.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 15:10 +0000, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  182a85f8a119c789610a9d464f4129ded9f3c107
> Gitweb:     http://git.kernel.org/tip/182a85f8a119c789610a9d464f4129ded9f3c107
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Wed, 16 Sep 2009 13:24:49 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 16 Sep 2009 16:44:33 +0200
> 
> sched: Disable wakeup balancing
> 
> Sysbench thinks SD_BALANCE_WAKE is too agressive and kbuild doesn't
> really mind too much, SD_BALANCE_NEWIDLE picks up most of the
> slack.
> 
> On a dual socket, quad core, dual thread nehalem system:
> 
> sysbench (--num_threads=16):
> 
>  SD_BALANCE_WAKE-: 13982 tx/s
>  SD_BALANCE_WAKE+: 15688 tx/s

I got the + and - confused it seems.. sysbench is faster without
BALANCE_WAKE.

> kbuild (-j16):
> 
>  SD_BALANCE_WAKE-: 47.648295846  seconds time elapsed   ( +-   0.312% )
>  SD_BALANCE_WAKE+: 47.608607360  seconds time elapsed   ( +-   0.026% )


