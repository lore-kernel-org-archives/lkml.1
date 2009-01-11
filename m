Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbZAKMFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbZAKMFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZAKMFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:05:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35260 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZAKMFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:05:00 -0500
Date: Sun, 11 Jan 2009 13:04:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 2/2] kernel/sched.c: forward declaration for
	'double_rq_lock' missing
Message-ID: <20090111120450.GA27796@elte.hu>
References: <1231664662-17104-1-git-send-email-steven@uplinklabs.net> <1231664662-17104-2-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231664662-17104-2-git-send-email-steven@uplinklabs.net>
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


* Steven Noonan <steven@uplinklabs.net> wrote:

> Impact: compile error eliminated
> 
> Added 'double_rq_lock' forward declaration, allowing double_rq_lock
> to be used in _double_lock_balance().
> 
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  kernel/sched.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)

applied to tip/sched/urgent, thanks Steven.

I have not seen such build failures myself - could you please send the 
.config that triggers it?

	Ingo
