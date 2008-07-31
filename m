Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbYGaLXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbYGaLXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYGaLXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:23:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55793 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbYGaLXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:23:03 -0400
Date: Thu, 31 Jul 2008 13:21:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 calgary: replace num_dma_pages() with
	iommu_num_pages()
Message-ID: <20080731112139.GA19670@elte.hu>
References: <1217248100-3019-1-git-send-email-joerg.roedel@amd.com> <20080728170904.GA10532@il.ibm.com> <20080731100103.GA488@elte.hu> <20080731101207.GS4851@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731101207.GS4851@amd.com>
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

> On Thu, Jul 31, 2008 at 12:01:03PM +0200, Ingo Molnar wrote:
> > * Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> > 
> > > On Mon, Jul 28, 2008 at 02:28:20PM +0200, Joerg Roedel wrote:
> > > > This patch removes the num_dma_pages() function from Calgary IOMMU code and
> > > > replaces it with the generic iommu_num_pages() function.
> > > > 
> > > > Cc: Muli Ben-Yehuda <muli@il.ibm.com>
> > > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > 
> > > Thanks Joerg,
> > > 
> > > Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
> > 
> > applied to tip/x86/iommu - thanks.
> 
> Ingo,
> 
> can you drop this patch please? It was already picked up by Andrew and 
> he has sent it to you. I already sent a drop message as a reply to the 
> patch Andrew has sent to you. I am currently working on a patch series 
> to make the iommu_num_pages function generic and this series will 
> include a new version of this patch.

ok, dropped - i was working the threads in chronological order so i 
havent processed the other thread yet. I'd eventually have gotten to 
your 'drop this mail please' email though :-)

	Ingo
