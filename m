Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbZDSJDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbZDSJDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 05:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZDSJDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 05:03:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43972 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbZDSJDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 05:03:22 -0400
Date: Sun, 19 Apr 2009 11:02:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
Message-ID: <20090419090208.GA30211@elte.hu>
References: <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org> <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain> <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 18 Apr 2009, Linus Torvalds wrote:
> > 
> > And that _is_ a really odd hole. I wonder what it is all about. 
> > But the approach does seem to have done the right thing.
> 
> I'll commit the reserve_region_with_split() change. There are no 
> actual users of it now, so committing that change doesn't really 
> do anything, but I like removing code, and with the only current 
> potential user actively wanting just the simpler behavior, why 
> keep the code around?

Cool! Yinghai, mind (re-)sending the latest version of the remaining 
two patches, so what we can pick this up into the x86 tree and get 
it tested? I'd say it's for v2.6.31. (unless someone can think of a 
strong reason to do this sooner.)

Thanks,

	Ingo
