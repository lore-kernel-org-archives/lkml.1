Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbYJKPBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbYJKPBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbYJKPA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:00:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37090 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbYJKPA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:00:57 -0400
Date: Sat, 11 Oct 2008 17:00:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
Message-ID: <20081011150022.GA18989@elte.hu>
References: <20081009190405.13A253CB@kernel> <20081009190406.1B257119@kernel> <20081009194350.GA31214@us.ibm.com> <1223585671.11830.40.camel@nimitz> <20081010084614.GA319@elte.hu> <20081011134803.GA1483@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011134803.GA1483@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> > In the long run, could we expect a (experimental) version of 
> > hibernation that would just use this checkpointing facility to 
> > hibernate? That would be way cool for users and for testing: we 
> > could do transparent kernel upgrades/downgrades via this form of 
> > hibernation, between CR-compatible kernels (!).
> 
> Well, if we could do that, I guess we could also use CR to 'hibernate' 
> your desktop then continue on your notebook. And yes that sounds cool.

yes.

> > Pie in the sky for sure, but way cool: it could propel Linux kernel 
> > testing to completely new areas - new kernels could be tried 
> > non-intrusively. (as long as a new kernel does not corrupt the CR 
> > data structures - so some good consistency and redundancy checking 
> > would be nice in the format!)
> 
> Well, for simple apps, it should not be that hard...

Generally, if something works for simple apps already (in a robust, 
compatible and supportable way) and users find it "very cool", then 
support for more complex apps is not far in the future.

but if you want to support more complex apps straight away, it takes 
forever and gets ugly.

	Ingo
