Return-Path: <linux-kernel-owner+w=401wt.eu-S1750765AbYGAGl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750765AbYGAGl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYGAGlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:41:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbYGAGli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:41:38 -0400
Date: Tue, 1 Jul 2008 08:35:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, laijs@cn.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russel <rusty@rustcorp.com.au>
Subject: Re: [PATCH] fix rcu vs hotplug race
Message-ID: <20080701063531.GD16642@elte.hu>
References: <20080623114941.GB3160@in.ibm.com> <20080624110144.GA8695@elte.hu> <20080626152728.GA24972@linux.vnet.ibm.com> <20080627044738.GC3419@in.ibm.com> <20080627051855.GD26167@in.ibm.com> <20080627054959.GB3309@linux.vnet.ibm.com> <20080627145845.GA9229@linux.vnet.ibm.com> <20080701053900.GB8205@in.ibm.com> <20080701061600.GF14658@elte.hu> <20080701062854.GD6131@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701062854.GD6131@linux.vnet.ibm.com>
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


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> Ingo,
> 
> I believe Gautham's fix at http://lkml.org/lkml/2008/6/27/9 is better 
> and also explains it better.

ah, indeed - picked that one up instead.

	Ingo
