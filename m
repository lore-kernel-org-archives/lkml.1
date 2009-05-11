Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbZEKNF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbZEKNF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZEKNFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:05:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57679 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbZEKNFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:05:17 -0400
Date: Mon, 11 May 2009 15:04:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: swiotlb support for Xen dom0
Message-ID: <20090511130455.GO13954@elte.hu>
References: <1241741842-7966-1-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241741842-7966-1-git-send-email-jeremy@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> This branch adds the swiotlb hooks for Xen dom0.  We use swiotlb 
> to handle various device drivers which assume that multipage DMA 
> transfers which are contigious in kernel memory are also 
> contigious in machine memory (mostly lower-performance devices, as 
> high-performance ones already do a good job of scatter-gather).
> 
> Following Fujita's suggestion, these changes remove a lot of the 
> placeholder stubs in arch/x86/kernel/pci-swiotlb.c and moves them 
> into the Xen-specific arch/x86/xen/pci-swiotlb.c.  (It still 
> relies on overriding the weak functions defined in lib/swiotlb.c.)
> 
> The following changes since commit 2af252ab26150b4411889c9eaf1af4c5bf03de78:
>   Jeremy Fitzhardinge (1):
>         xen: checkpatch cleanups

Would be nice to have a pull request for this with Fujita-san's acks 
embedded in the commits, and with a tree based against tip:x86/xen.

	Ingo
