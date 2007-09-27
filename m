Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbXI0K5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbXI0K5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 06:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbXI0K47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 06:56:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55168 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbXI0K46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 06:56:58 -0400
Date: Thu, 27 Sep 2007 12:56:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070927105637.GA17936@elte.hu>
References: <20070926085202.GE3337@deprecation.cyrius.com> <1190802208.7318.5.camel@Homer.simpson.net> <20070926104814.GM3337@deprecation.cyrius.com> <20070926112137.GA13876@elte.hu> <20070926112919.GN3337@deprecation.cyrius.com> <20070927094940.GA2894@elte.hu> <20070927105453.GE15346@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927105453.GE15346@deprecation.cyrius.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0212]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Michlmayr <tbm@cyrius.com> wrote:

> * Ingo Molnar <mingo@elte.hu> [2007-09-27 11:49]:
> > Martin, could you check the iperf patch below instead of the yield
> > patch - does it solve the iperf performance problem equally well,
> > and does CPU utilization drop for you too?
> 
> Yes, it works and CPU goes down too.

i'm curious by how much does CPU go down, and what's the output of 
iperf? (does it saturate full 100mbit network bandwidth)

	Ingo
