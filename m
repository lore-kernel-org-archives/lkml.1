Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZDGJVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZDGJVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZDGJV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:21:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36863 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbZDGJVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:21:25 -0400
Date: Tue, 7 Apr 2009 11:21:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] various perf counter bits
Message-ID: <20090407092108.GA17301@elte.hu>
References: <20090406094458.977814421@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090406094458.977814421@chello.nl>
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

> new features:
>   - event limit
>   - record time stamps
>   - SIGIO support
> 
> fixes:
>   - mlock accounting
>   - swcounter task clock vs NMI readout deadlock
>   - comments and such

Looks good so i've applied it, but got this build-failure on 32-bit:

  kernel/perf_counter.c:2345: error: implicit declaration of function atomic64_xchg

atomic64_xchg() is not implemented yet on the 32-bit side.

	Ingo
