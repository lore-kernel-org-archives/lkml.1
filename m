Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbYI3HLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbYI3HLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYI3HLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:11:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60742 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbYI3HLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:11:19 -0400
Date: Tue, 30 Sep 2008 09:10:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Tracepoints fix reentrancy
Message-ID: <20080930071047.GD30927@elte.hu>
References: <20080930055112.GC16961@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930055112.GC16961@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> The tracepoints had the same problem markers did have wrt reentrancy. Apply a
> similar fix using a rcu_barrier after each tracepoint mutex lock.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: "Frank Ch. Eigler" <fche@redhat.com>
> CC: Lai Jiangshan <laijs@cn.fujitsu.com>

applied to tip/tracing/ftrace, thanks Mathieu!

	Ingo
