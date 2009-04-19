Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbZDSJHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbZDSJHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 05:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbZDSJHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 05:07:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50426 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbZDSJHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 05:07:21 -0400
Date: Sun, 19 Apr 2009 11:06:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
Message-ID: <20090419090615.GA30631@elte.hu>
References: <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org> <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain> <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain> <20090419090208.GA30211@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419090208.GA30211@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Cool! Yinghai, mind (re-)sending the latest version of the 
> remaining two patches, so what we can pick this up into the x86 
> tree and get it tested? I'd say it's for v2.6.31. (unless someone 
> can think of a strong reason to do this sooner.)

Hm, there's one patch in that lot that does:

 drivers/pci/bus.c	 |    8 +++++++-
 drivers/pci/probe.c     |    8 ++++++--
 drivers/pci/setup-bus.c |   40 +++++++++++++++++++++++++++++++---------
 3 files changed, 44 insertions(+), 12 deletions(-)

Which should go via the PCI tree.

I can set up an isolated x86/pci-gap topic that i'll send to Jesse 
to pull (once it looks to be stable), as the other patches modify 
the e820 code which we'd like to test in the x86 tree first.

Jesse, Linus, Yinghai, does that look like a good plan to you?

	Ingo
