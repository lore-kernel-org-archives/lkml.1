Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbXFLVix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbXFLVix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbXFLVin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:38:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbXFLVim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:38:42 -0400
Date: Tue, 12 Jun 2007 23:37:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070612213758.GA6173@elte.hu>
References: <20070609210507.GA29194@elte.hu> <20070611011954.GG27982@linux.vnet.ibm.com> <20070611073634.GB32446@elte.hu> <20070611144401.GA9102@linux.vnet.ibm.com> <20070611153855.GA21136@elte.hu> <20070611155527.GD9102@linux.vnet.ibm.com> <20070611171806.GH9102@linux.vnet.ibm.com> <20070611204427.GK9102@linux.vnet.ibm.com> <20070611221803.GL9102@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611221803.GL9102@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Not a biggie for me, since I can easily do the taskset commands to 
> force the processes to spread out, but I am worried that casual users 
> of rcutorture won't know to do this -- thus not really torturing RCU. 
> It would not be hard to modify rcutorture to affinity the tasks so as 
> to spread them, but this seems a bit ugly.

does it get any better if you renice them from +19 to 0? (and then back 
to +19?)

	Ingo
