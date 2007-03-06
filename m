Return-Path: <linux-kernel-owner+w=401wt.eu-S933166AbXCFJLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166AbXCFJLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934003AbXCFJLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:11:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41411 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934002AbXCFJL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:11:26 -0500
Date: Tue, 6 Mar 2007 10:10:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Gerd Hoffmann <kraxel@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
Message-ID: <20070306091006.GA26073@elte.hu>
References: <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <45ED2E63.3070700@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ED2E63.3070700@vmware.com>
User-Agent: Mutt/1.4.2.2i
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


* Zachary Amsden <zach@vmware.com> wrote:

> > > reduces the QA effort.  You still have 5 Hypervisors you have to 
> > > test against.
> >
> > yes, just like we have thousands of separate PC boards to support. 
> > But as long as the basic ABI is the same, the QA effort on the Linux 
> > kernel side is alot more focused. (Distros still have 
> > 18446744073709551616 total combinations to QA, and have to make an 
> > educated guess to reduce that to a more manageable number.)
> 
> But hardware PC boards don't do anything as remotely complicate as 
> changing the semantics required for correctness in you MMU 
> implementation. [...]

ugh, PC boards are actually far worse and far more diverse than any 
variances between hypervisors, but i digress.

anyway, my point stands: the Linux kernel is significantly more 
maintainable and easier to QA if it has only a single 'external' 
hypervisor ABI to worry about - and that might as well be VMI. This is a 
really obvious point, i expected the discussion to center more around 
the specifics of such a move ;-)

	Ingo
