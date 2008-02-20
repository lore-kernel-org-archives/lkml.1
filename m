Return-Path: <linux-kernel-owner+w=401wt.eu-S1762386AbYBTKjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762386AbYBTKjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYBTKiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:38:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33269 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbYBTKiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:38:54 -0500
Date: Wed, 20 Feb 2008 11:38:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 0/8] AMD opteron mm config numa etc
Message-ID: <20080220103831.GH3881@elte.hu>
References: <200802190319.28699.yinghai.lu@sun.com> <20080219112322.GD7204@elte.hu> <20080219175339.GB8344@kroah.com> <20080220063752.GD7493@elte.hu> <20080220015115.a5989384.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220015115.a5989384.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 20 Feb 2008 07:37:52 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Note: Andrew might get grumpy when 
> > your PCI tree starts changing nearby places in arch/x86/pci again and it 
> > clashes with these changes in x86.git
> 
> s/Andrew/Stephen/I hope/;)/
> 
> Hopefully we can soon start feeding these more problematic trees into 
> linux-next and yes, Stephen will need some more thought/support from 
> his upstreams to make that viable.

btw., the correct metric would be "real user-side regressions per 
commit" (maybe real regressions per line of code changed), not "number 
of commits". With the latter metric, x86.git is "problematic". For the 
former, it's much less so ;-)

i.e. you should punish buggy trees that affect real testers out there, 
not high-flux trees that by virtue of their flux cause more integration 
work.

	Ingo
