Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbYBTGiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbYBTGiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYBTGiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:38:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42329 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbYBTGiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:38:13 -0500
Date: Wed, 20 Feb 2008 07:37:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] AMD opteron mm config numa etc
Message-ID: <20080220063752.GD7493@elte.hu>
References: <200802190319.28699.yinghai.lu@sun.com> <20080219112322.GD7204@elte.hu> <20080219175339.GB8344@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219175339.GB8344@kroah.com>
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


* Greg KH <greg@kroah.com> wrote:

> > > could make up for system that system have acpi problem or still 
> > > can mmconf and numa when acpi=off
> > 
> > Greg, any deep objections against these patches? (other than that 
> > they need a good amount of testing) I personally think that the more 
> > independent the kernel is of the whims of the BIOS, the better ...
> 
> No objection from me, other than they need a LOT of testing. [...]

ok - have queued it up for v2.6.26. Note: Andrew might get grumpy when 
your PCI tree starts changing nearby places in arch/x86/pci again and it 
clashes with these changes in x86.git - in that case please pick up the 
full lot from x86.git#testing and carry it in the PCI tree. (or, 
alternatively, send me any trivial, arch/x86-only PCI bits to 
x86.git#testing so that we can keep it and test it all in a single place 
- whichever approach is more convenient to you)

> [...] Oh, and the networking patch is still wrong, and the poster has 
> been told this numerous times, which makes me wonder how well the pci 
> bridge patch was tested...

i think the optimization should be more correct now than in the past, 
its purpose and dependencies just have not been communicated fully. 
We'll get there eventually :-)

	Ingo
