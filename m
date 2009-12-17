Return-Path: <linux-kernel-owner+w=401wt.eu-S1764167AbZLQIuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764167AbZLQIuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 03:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762364AbZLQIue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 03:50:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34046 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759324AbZLQIud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 03:50:33 -0500
Date: Thu, 17 Dec 2009 09:50:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] perf lock: Fix output of tracing lock events
Message-ID: <20091217085023.GC1901@elte.hu>
References: <1260934105-4472-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1260934105-4472-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260934105-4472-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> This patch adds address of lockdep_map to each lock events.
> perf lock uses these addresses as IDs of lock instances.
> 
> And this removes waittime from output of lock_acquired event.
> The value will be caliculated in userspace based on timestamp.
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/trace/events/lock.h |   27 ++++++++++++++++++---------
>  kernel/lockdep.c            |    2 +-
>  2 files changed, 19 insertions(+), 10 deletions(-)

Frederic, Peter, do these two patches look good to you? We can apply them to 
make subsequent perf lock work easier.

Thanks,

	Ingo
