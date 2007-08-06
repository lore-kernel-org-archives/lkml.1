Return-Path: <linux-kernel-owner+w=401wt.eu-S1765003AbXHFPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765003AbXHFPOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762350AbXHFPOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:14:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49878 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762131AbXHFPOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:14:10 -0400
Date: Mon, 6 Aug 2007 17:13:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 1/2] sysctl: remove binary sysctls from
	kernel.sched_domain
Message-ID: <20070806151349.GA2854@elte.hu>
References: <20070806123655.GC6634@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806123655.GC6634@localhost.sw.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@sw.ru> wrote:

> kernel.sched_domain hierarchy is under CTL_UNNUMBERED and thus 
> unreachable to sysctl(2). Generating .ctl_number's in such situation 
> is not useful.

thanks - i've applied your patch to my tree.

	Ingo
