Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYK1LbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYK1LbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYK1LbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:31:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37038 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbYK1LbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:31:09 -0500
Date: Fri, 28 Nov 2008 12:31:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Liming Wang <liming.wang@windriver.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/1] ftrace: improve seq_operation of ftrace
Message-ID: <20081128113103.GB18333@elte.hu>
References: <1227845601-4691-1-git-send-email-liming.wang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227845601-4691-1-git-send-email-liming.wang@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Liming Wang <liming.wang@windriver.com> wrote:

> Impact: make position computing more sane
> 
> First remove useless ->pos field. Then we needn't check seq_printf
> in .show like other place.
> 
> Signed-off-by: Liming Wang <liming.wang@windriver.com>
> Reviewed-by: Bruce Ashfield <bruce.ashfield@windriver.com>
> ---
>  kernel/trace/ftrace.c |   27 ++++++++++-----------------
>  1 files changed, 10 insertions(+), 17 deletions(-)

appiled to tip/tracing/ftrace, thanks!

	Ingo
