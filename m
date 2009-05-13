Return-Path: <linux-kernel-owner+w=401wt.eu-S1761181AbZEMQ5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761181AbZEMQ5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760150AbZEMQ51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:57:27 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58780 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759953AbZEMQ51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:57:27 -0400
Date: Wed, 13 May 2009 22:27:24 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: Re: perf counter issue -
	WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
Message-ID: <20090513165724.GA32707@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20090513165433.GD16373@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513165433.GD16373@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 10:24:33PM +0530, Srivatsa Vaddagiri wrote:
> I am hitting this warning in kernel/exit.c (latest -tip code):
> 
> WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
> 
> I was using perf counters against a java benchmark.

Basically using perf counters as:

	$ perf stat java ....

- vatsa
