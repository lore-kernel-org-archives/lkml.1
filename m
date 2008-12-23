Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbYLWRrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbYLWRrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 12:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYLWRrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 12:47:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43067 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYLWRrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 12:47:16 -0500
Date: Tue, 23 Dec 2008 18:46:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] ring-buffer: updates for 2.6.28
Message-ID: <20081223174653.GA21738@elte.hu>
References: <20081223163223.625941559@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223163223.625941559@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> These two patches should go to 2.6.28. They are fixes to the ring buffer 
> for bugs that will make the ring buffer stop reading, and/or produce a 
> false positive.
> 
> If these are too late for 2.6.28, then we probably should get them at 
> least to the stable branch and queued for 2.6.28.1.

yes, they are too late - the .28 release is tomorrow.

> Steven Rostedt (2):
>       ring-buffer: fix dangling commit race
>       ring-buffer: prevent false positive warning
> 
> ----
>  kernel/trace/ring_buffer.c |   19 +++++++++++++++++--
>  1 files changed, 17 insertions(+), 2 deletions(-)

pulled into tip/tracing/ring-buffer. I also marked them Cc: 
stable@kernel.org, so they will be picked up for .28.1. (they apply 
cleanly to both the latest tracing tree and latest mainline as well)

	Ingo
