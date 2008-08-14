Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYHNI5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYHNI5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYHNI5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:57:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40616 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbYHNI5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:57:04 -0400
Date: Thu, 14 Aug 2008 10:56:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] x86, xsave: use BUG_ON() instead of BUILD_BUG_ON()
Message-ID: <20080814085647.GE1650@elte.hu>
References: <20080813183856.964126000@linux-os.sc.intel.com> <20080813183857.246823000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813183857.246823000@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> All these structure sizes are runtime determined. So use a runtime bug 
> check.

applied these patches to tip/x86/xsave:

 f65bc21: x86, xsave: use BUG_ON() instead of BUILD_BUG_ON()
 ed40595: x86, xsave: clear the user buffer before doing fxsave/xsave
 ee2b92a: x86, xsave: remove the redundant access_ok() in setup_rt_frame()

thanks Suresh.

	Ingo
