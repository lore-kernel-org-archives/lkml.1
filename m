Return-Path: <linux-kernel-owner+w=401wt.eu-S1764880AbXGPV4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764880AbXGPV4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763387AbXGPVzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:55:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762469AbXGPVzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:55:52 -0400
Date: Mon, 16 Jul 2007 23:55:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ian Kent <raven@themaw.net>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070716215541.GA27171@elte.hu>
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com> <469BE462.9030004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469BE462.9030004@redhat.com>
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


* Chuck Ebbert <cebbert@redhat.com> wrote:

> On 07/13/2007 05:19 PM, Bill Davidsen wrote:
> > 
> > I should really go back to 2.6.21.6, 2.6.22 has many bizarre behaviors
> > with FC6. Automount starts taking 30% of CPU (unused at the moment)
> 
> Can you confirm whether CFS is involved, i.e. does it spin like that 
> even without the CFS patch applied?

hmmm .... could you take out the kernel/time.c (sys_time()) changes from 
the CFS patch, does that solve the automount issue? If yes, could 
someone take a look at automount and check whether it makes use of 
time(2) and whether it combines it with finer grained time sources?

	Ingo
