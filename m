Return-Path: <linux-kernel-owner+w=401wt.eu-S1761740AbYAHQ2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761740AbYAHQ2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761626AbYAHQ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:28:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48882 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761622AbYAHQ2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:28:21 -0500
Date: Tue, 8 Jan 2008 17:27:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Robert Hancock <hancockr@shaw.ca>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, akpm@osdl.org,
       rajesh.shah@intel.com, greg@kroah.com
Subject: Re: MCFG ACPI patch in git-x86 causes boot regression
Message-ID: <20080108162759.GG32273@elte.hu>
References: <20080107224757.GA2336@basil.nowhere.org> <200801071452.15045.jbarnes@virtuousgeek.org> <4782B66E.8050400@shaw.ca> <20080108010110.GB16156@one.firstfloor.org> <4782CBF2.6030208@shaw.ca> <20080108081543.GF31838@elte.hu> <20080108161409.GB31504@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108161409.GB31504@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > > http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/broken-out/pci-disable-decoding-during-sizing-of-bars.patch
> > >
> > > Without this change a bunch of machines fail to boot even without 
> > > the MCFG change (since their MCFG was E820 reserved and so the old 
> > > validation check passed).
> > 
> > Andi, can you confirm that your box boots fine with that patch 
> > applied?
> 
> Yes it does.

thanks for testing it. (and thanks for finding & reporting the problem) 
I've added that patch to x86.git, right before:

  Subject: x86: validate against ACPI motherboard resources

this should be the only dependency AFAICS.

	Ingo
