Return-Path: <linux-kernel-owner+w=401wt.eu-S1031255AbXECMhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031255AbXECMhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031248AbXECMhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:37:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42556 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031247AbXECMhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:37:03 -0400
Date: Thu, 3 May 2007 14:36:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v7
Message-ID: <20070503123655.GA705@elte.hu>
References: <200704300820.49078.a1426z@gawab.com> <20070503074552.GA14960@elte.hu> <20070503080706.GA18427@elte.hu> <200705031416.50928.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705031416.50928.a1426z@gawab.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Boldi <a1426z@gawab.com> wrote:

> [...] But I can still see these awful latency blips in the presence of 
> negatively niced chew.c at -10 and two chew.c's at nice 0. [...]

of course: you asked for the two chew's to be treated like that and CFS 
delivered it! :-)

nice -10 means the two chew's will get ~90+% of the CPU time, and all 
other nice 0 tasks will get <10% of CPU time.

in the previous mail i have described the new exponential-scale nice 
levels that CFS introduces. In practice this means that vanilla kernel's 
nice -20 level is roughly equivalent to CFS's nice -6. CFS's nice -10 
would be roughly equivalent to vanilla nice -80 (if it existed).

	Ingo
