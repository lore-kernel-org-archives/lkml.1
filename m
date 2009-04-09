Return-Path: <linux-kernel-owner+w=401wt.eu-S933652AbZDIJQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbZDIJQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933323AbZDIJQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:16:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38842 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933199AbZDIJQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:16:41 -0400
Date: Thu, 9 Apr 2009 11:16:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] perf_counter: optimize mmap/comm tracking
Message-ID: <20090409091622.GA23636@elte.hu>
References: <20090409085342.799915215@chello.nl> <20090409085524.427173196@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409085524.427173196@chello.nl>
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

> +static atomic_t nr_comm_tracking __read_mostly;

hm, nr_comm_tracking is not actually used by any fastpath - just 
increased and then decreased.

	Ingo
