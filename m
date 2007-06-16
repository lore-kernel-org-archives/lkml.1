Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbXFPSlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbXFPSlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 14:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXFPSlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 14:41:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41190 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbXFPSlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 14:41:13 -0400
Date: Sat, 16 Jun 2007 20:40:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: malc <av1474@comtv.ru>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] sched: accurate user accounting
Message-ID: <20070616184021.GA3887@elte.hu>
References: <20070328113743.GA5615@elte.hu> <Pine.LNX.4.64.0706142149020.2991@linmac.oyster.ru> <20070614204253.GA14076@elte.hu> <Pine.LNX.4.64.0706150052190.3404@linmac.oyster.ru> <20070614211828.GA21243@elte.hu> <Pine.LNX.4.64.0706150129430.3526@linmac.oyster.ru> <46720B19.5000006@linux.vnet.ibm.com> <Pine.LNX.4.64.0706151002530.2175@linmac.oyster.ru> <4673E3D9.2020300@linux.vnet.ibm.com> <Pine.LNX.4.64.0706161732040.2619@linmac.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706161732040.2619@linmac.oyster.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* malc <av1474@comtv.ru> wrote:

> > Interesting, the idle time accounting (done from 
> > account_system_time()) has not changed. Has your .config changed? 
> > Could you please send it across. I've downloaded apc and I am trying 
> > to reproduce your problem.
> 
> http://www.boblycat.org/~malc/apc/cfs/ has config for 2.6.21 an the 
> diff against 2.6.21.4-cfs-v16.

hm. Could you add this to your kernel boot command line:

     highres=off nohz=off

and retest, to inquire whether this problem is independent of any 
timer-events effects?

	Ingo
