Return-Path: <linux-kernel-owner+w=401wt.eu-S1762480AbZDIJDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480AbZDIJDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZDIJDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:03:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42924 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616AbZDIJDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:03:46 -0400
Date: Thu, 9 Apr 2009 11:03:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] perf_counter: fixes and an optimization
Message-ID: <20090409090331.GA17888@elte.hu>
References: <20090409085342.799915215@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409085342.799915215@chello.nl>
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

>  - fixes an off-by-one in string handling
>  - fixes the mmap tracing to provide the full path
>  - allows unpriviledged use of cpu counters

i made the variable here __read_mostly.

>  - optimize mmap/comm tracing

Applied, thanks!

	Ingo
