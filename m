Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbYF3MWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbYF3MWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 08:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYF3MWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 08:22:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52129 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbYF3MWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 08:22:37 -0400
Date: Mon, 30 Jun 2008 14:22:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 02/34] AMD IOMMU: add header file for driver data
	structures and defines
Message-ID: <20080630122208.GC25092@elte.hu>
References: <1214508490-29683-3-git-send-email-joerg.roedel@amd.com> <20080629235410O.fujita.tomonori@lab.ntt.co.jp> <20080629151454.GA6692@amd.com> <20080630073848J.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630073848J.fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > > ---
> > > >  include/asm-x86/amd_iommu_types.h |  242 +++++++++++++++++++++++++++++++++++++
> > > >  1 files changed, 242 insertions(+), 0 deletions(-)
> > > >  create mode 100644 include/asm-x86/amd_iommu_types.h
> > > 
> > > Is necessary to make this file visible to everyone by putting this in
> > > include/asm?
> > 
> > The alternative was to put this file in arch/x86/kernel/. But I don't
> > think its the right place for include files. We have include/ for that.
> 
> Hmm, really? It's the right thing in the SCSI subsystem at least. You 
> don't need to put a header file having only private stuff in include/.

it's OK to have it in include/asm-x86/ (in fact i'd prefer it to stay 
there). It includes hardware API details, etc.

	Ingo
