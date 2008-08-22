Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbYHVGfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbYHVGfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYHVGfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:35:34 -0400
Received: from 8bytes.org ([88.198.83.132]:53313 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbYHVGfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:35:33 -0400
Date: Fri, 22 Aug 2008 08:35:30 +0200
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCH] x86: make gart_alloc_coherent return zeroed memory
Message-ID: <20080822063530.GA16706@8bytes.org>
References: <20080821225038E.fujita.tomonori@lab.ntt.co.jp> <1219339707-30592-1-git-send-email-joerg.roedel@amd.com> <20080822081517F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822081517F.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 08:19:35AM +0900, FUJITA Tomonori wrote:
> On Thu, 21 Aug 2008 19:28:27 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > The dma_alloc_coherent function should return memory set to zero. This patch
> > adds this to the GART implementation.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/pci-gart_64.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> This should be foiled to the first patch in the patchset. No good
> reason to push a patch that might cause a problem.

The reason is, that in my experience, Ingo prefers update patches
instead replacements once he has merged something.

Joerg

