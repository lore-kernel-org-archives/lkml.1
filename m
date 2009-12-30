Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbZL3JZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbZL3JZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZL3JZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:25:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58953 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbZL3JZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:25:38 -0500
Date: Wed, 30 Dec 2009 10:25:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, simon.kagstrom@netinsight.net,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: might_sleep(): Make file parameter
 const char *
Message-ID: <20091230092511.GB10486@elte.hu>
References: <20091223110818.442d848e@marrow.netinsight.se>
 <tip-d894837f23f491aa7ed167aae767fc07cfe6e6e6@git.kernel.org>
 <1262088708.7135.133.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262088708.7135.133.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-12-28 at 10:10 +0000, tip-bot for Simon Kagstrom wrote:
> 
> > Fixes a warning when building with g++:
> 
> However did you manage to build stuff with g++? The kernel very
> frequently uses C++ keywords for other things.

yeah, good question. Alas the change itself (const propagation) looked good so 
i applied it.

	Ingo
