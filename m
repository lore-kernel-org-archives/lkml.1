Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYLDInV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYLDInV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYLDInF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:43:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49648 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbYLDInD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:43:03 -0500
Date: Thu, 4 Dec 2008 09:42:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Liming Wang <liming.wang@windriver.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ftrace: avoid duplicated function when writing
	set_graph_function
Message-ID: <20081204084250.GH32594@elte.hu>
References: <20081203203828.920111079@goodmis.org> <1228371889-11195-1-git-send-email-liming.wang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228371889-11195-1-git-send-email-liming.wang@windriver.com>
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

> Impact: fix a bug
> 
> when writing function to set_graph_function, we should check whether it
> has existed in set_graph_function to avoid duplicating.
> 
> Signed-off-by: Liming Wang <liming.wang@windriver.com>
> ---
>  kernel/trace/ftrace.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)

applied to tip/tracing/ftrace, thanks!

	Ingo
