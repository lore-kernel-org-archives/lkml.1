Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbYINOoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbYINOoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYINOoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:44:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34078 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYINOoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:44:38 -0400
Date: Sun, 14 Sep 2008 16:44:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: gart alloc_coherent does virtual mapppings
	only when necessary
Message-ID: <20080914144420.GE12522@elte.hu>
References: <1221142128-28350-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1221142128-28350-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1221142128-28350-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080911141613.GL24392@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911141613.GL24392@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0087]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Looks good to me.
> 
> On Thu, Sep 11, 2008 at 11:08:48PM +0900, FUJITA Tomonori wrote:
> > gart alloc_coherent need to do virtual mapppings only when an
> > allocated buffer is not DMA-capable for a device.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: Joerg Roedel <joerg.roedel@amd.com>
> 
> Acked-by: Joerg Roedel <joerg.roedel@amd.com>

applied to tip/x86/iommu, thanks.

	Ingo
