Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbYLSIPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbYLSIPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 03:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYLSIPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 03:15:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34190 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbYLSIPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 03:15:37 -0500
Date: Fri, 19 Dec 2008 09:15:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>, hpa@zytor.com, tglx@linutronix.de,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Intel x86_64 llc_shared_map/cpu_llc_id anomolies
Message-ID: <20081219081517.GA7859@elte.hu>
References: <20081212214256.GA20559@sgi.com> <20081219020921.GD26490@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219020921.GD26490@linux-os.sc.intel.com>
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

> > Is cpu_llc_id supposed to be unique across blades?  I assume 
> > llc_shared_map should not be showing shared cache across blades.
> 
> x86 folks, Appended patch fixes the reported issue. Please apply.

applied, thanks Suresh!

Not for v2.6.28 because that is going to be released in a few days and 
these sorts of changes can easily cause boot regressions - but i marked it 
for -stable backport so it will hit .28.1 if everything is fine.

	Ingo
