Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYKURDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYKURDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYKURDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:03:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53107 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbYKURDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:03:39 -0500
Date: Fri, 21 Nov 2008 18:03:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] DMA-API debugging facility
Message-ID: <20081121170321.GH733@elte.hu>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227286492.4901.208.camel@macbook.infradead.org> <20081121165722.GD1386@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121165722.GD1386@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Fri, Nov 21, 2008 at 04:54:52PM +0000, David Woodhouse wrote:
> > On Fri, 2008-11-21 at 17:26 +0100, Joerg Roedel wrote:
> > > this patchset introduces code to debug drivers usage of the DMA-API.
> > > Tests with hardware IOMMUs have shown several bugs in drivers
> > > regarding the usage of that API.
> > > Problems were found especially in network card drivers.
> > 
> > This is really useful -- but surely it shouldn't be x86-specific?
> > 
> > All the code except the hooks in the architecture's dma_map_single() et
> > al functions could be generic, couldn't it?
> 
> Yes, in principle we could move most of it to generic code. There is 
> nothing architecture specific in it. Anybody who prefers this to be 
> arch/x86 before moving it to lib/?

yeah, we want to make it generic once it works.

but my comments about the allocation needs to be addressed (see my 
comments on [03/10]), and solving that will likely impact the 
structure of the approach in a way that will generalize it anyway, as 
a side-effect.

	Ingo
