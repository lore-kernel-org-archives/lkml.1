Return-Path: <linux-kernel-owner+w=401wt.eu-S932896AbXA1V20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbXA1V20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 16:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932899AbXA1V20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 16:28:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47776 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932896AbXA1V2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 16:28:25 -0500
Date: Sun, 28 Jan 2007 22:26:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <greg@kroah.com>, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
       linuxppc-dev@ozlabs.org, Brice Goglin <brice@myri.com>,
       shaohua.li@intel.com, linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/6] MSI portability cleanups
Message-ID: <20070128212618.GA11547@elte.hu>
References: <1169714047.65693.647693675533.qpush@cradle> <m1hcubq6re.fsf@ebiederm.dsl.xmission.com> <1170015805.26655.15.camel@localhost.localdomain> <45BD0BDC.40205@garzik.org> <m1bqkiq25v.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bqkiq25v.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> I'm not arguing against an operations based approach.  I'm arguing for 
> simple obviously correct steps, and not throwing the baby out with the 
> bath water.
> 
> My patches should be a precursor to an operations based approach
> because they are simple step from where we are now.

yeah. I'd say your approach is to go from A to B:

  [A] -----------------------------------------------------> [B]
                                                              |
                                                             [C]

while there might be some other arguments that "no, lets go to C 
instead", i say lets not throw away the already implemented and already 
working and nicely layered [A]->[B] transition, just because there's an 
argument whether the end result should be 'B' or 'C'. Unless someone who 
wants to see 'C' produces a patchset that walks the whole way i dont see 
any reason to not go with your patchset. It clearly removes alot of 
cruft.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
