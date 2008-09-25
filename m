Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYIYJEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYIYJEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 05:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYIYJE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 05:04:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40651 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbYIYJEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 05:04:25 -0400
Date: Thu, 25 Sep 2008 11:04:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, joerg.roedel@amd.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/3] x86: restore old GART alloc_coherent
Message-ID: <20080925090402.GA16734@elte.hu>
References: <1222256917-14321-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222256917-14321-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This pachset is against tip/iommu.
> 
> What this patchset does is restoring old GART alloc_coherent behavior 
> (before the alloc_coherent rewrite):
> 
> http://lkml.org/lkml/2008/8/12/200

applied your fixes to tip/x86/iommu:

 1615965: x86 gart: remove unnecessary initialization
 1d99088: x86: restore old GART alloc_coherent behavior
 ecef533: revert "x86: make GART to respect device's dma_mask about virtual mappings"
 9f6ac57: x86: export pci-nommu's alloc_coherent

thanks Fujita!

	Ingo
