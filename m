Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752321AbYLRM1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbYLRM1W (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYLRM1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:27:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57597 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYLRM1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:27:12 -0500
Date: Thu, 18 Dec 2008 13:26:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, iommu@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 gart: don't complain if no AMD GART found
Message-ID: <20081218122635.GB25715@elte.hu>
References: <20081217195234.13603.96737.stgit@bob.kio> <20081217205308.GA11528@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217205308.GA11528@amd.com>
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

> On Wed, Dec 17, 2008 at 12:52:34PM -0700, Bjorn Helgaas wrote:
> > It's perfectly normal for no AMD GART to be present, e.g., if you have
> > Intel CPUs.  None of the other iommu_init() functions makes noise when
> > it finds nothing.
> 
> True, there are even 64bit AMD processors without GART.
> 
> Ingo,
> 
> do you want to pick this patch up or should I do it?
> 
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> Acked-by: Joerg Roedel <joerg.roedel@amd.com>

I have applied it to tip/x86/urgent, thanks guys!

	Ingo
