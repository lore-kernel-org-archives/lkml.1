Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYKKVAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYKKVAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbYKKU7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:59:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41389 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbYKKU7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:59:14 -0500
Date: Tue, 11 Nov 2008 21:59:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] ftrace: updates for linux-tip
Message-ID: <20081111205905.GA14583@elte.hu>
References: <20081111204555.890501283@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111204555.890501283@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Steven Rostedt (3):
>       ring-buffer: buffer record on/off switch
>       ring-buffer: add reader lock
>       ring-buffer: clean up warn ons
> 
> ----
>  include/linux/ring_buffer.h |    3 +
>  kernel/trace/ftrace.c       |    8 +-
>  kernel/trace/ring_buffer.c  |  351 ++++++++++++++++++++++++++++--------------
>  3 files changed, 239 insertions(+), 123 deletions(-)

pulled, thanks Steve!

btw., "ring-buffer: add reader lock" solves the ring-buffer WARN_ON 
bug i hit and reported earlier today.

	Ingo
