Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYJCPII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYJCPII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYJCPH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:07:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55404 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbYJCPH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:07:57 -0400
Date: Fri, 3 Oct 2008 17:07:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH -tip] Tracing/fastboot: Only trace non-module initcalls
Message-ID: <20081003150741.GA22001@elte.hu>
References: <48E62089.7050006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E62089.7050006@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> At this time, only built-in initcalls interest us.
> We can't really produce a relevant graph if we include
> the modules initcall too.
> 
> I had good results after this patch (see svg in attachment).
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/linux/ftrace.h    |    2 ++
>  init/main.c               |    1 +
>  kernel/trace/trace_boot.c |   11 ++++++++---
>  3 files changed, 11 insertions(+), 3 deletions(-)

applied to tip/tracing/fastboot, thanks,

	Ingo
