Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbZDTIr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbZDTIr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 04:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZDTIrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 04:47:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43783 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbZDTIrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 04:47:49 -0400
Date: Mon, 20 Apr 2009 10:47:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] tracing: recursion protection fixes
Message-ID: <20090420084729.GB32625@elte.hu>
References: <1240178868-18218-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240178868-18218-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> Here are two fixes for tracing recursion protection.
> The first slightly improves debugging in case of recursion detection.
> The second fixes a spurious warning and tracing disabling while
> activating a filter.
> 
> The following changes since commit 8e668b5b3455207e4540fc7ccab9ecf70142f288:
>   Steven Rostedt (1):
>         tracing: remove format attribute of inline function
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/recursion
> 
> Frederic Weisbecker (2):
>       tracing/core: Add current context on tracing recursion warning
>       tracing/ring-buffer: unlock recursion protection on discard
> 
>  kernel/trace/ring_buffer.c |   25 ++++++++++++++++++++-----
>  1 files changed, 20 insertions(+), 5 deletions(-)

Pulled, thanks Frederic! Steve, any objections?

	Ingo
