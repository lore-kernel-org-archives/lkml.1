Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYLVPBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYLVPBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 10:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYLVPAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 10:00:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37287 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbYLVPAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 10:00:52 -0500
Date: Mon, 22 Dec 2008 16:00:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Fabio Comolli <fabio.comolli@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: TSC not updating after resume: Bug or Feature?
Message-ID: <20081222150021.GA13839@elte.hu>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <1229592279.9487.133.camel@twins> <20081218123924.GH25715@elte.hu> <200812182319.57235.rjw@sisk.pl> <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain> <alpine.LFD.2.00.0812212031220.4548@localhost.localdomain> <b637ec0b0812211443u1ca9c11du5d61c41e3d82bc16@mail.gmail.com> <alpine.LFD.2.00.0812221543550.3723@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812221543550.3723@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> > By the way, I don't know if it matters but the problema happened with 
> > in-kernel hibernation and also in out-of-tree TuxOnIce hibernation. 
> > Maybe this can help debugging the issue, I don't know.
> 
> Hmm, does not ring a bell here. Can you please apply the patch below to 
> mainline and retest ?

... and he should send a dmesg after a suspend cycle, right?

	Ingo
