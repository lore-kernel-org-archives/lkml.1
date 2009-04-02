Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbZDBL3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbZDBL3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756362AbZDBL3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:29:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47685 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbZDBL3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:29:08 -0400
Date: Thu, 2 Apr 2009 13:28:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] perf_counter: move the event overflow output bits
	to record_type
Message-ID: <20090402112852.GD10828@elte.hu>
References: <20090402091158.291810516@chello.nl> <20090402091319.151921176@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402091319.151921176@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Per suggestion from Paul, move the event overflow bits to record_type
> and sanitize the enums a bit.
> 
> Breaks the ABI -- again ;-)
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/perf_counter.h |   50 ++++++++++++---------
>  kernel/perf_counter.c        |   99 ++++++++++++++++---------------------------
>  2 files changed, 67 insertions(+), 82 deletions(-)

nice cleanup!

	Ingo
