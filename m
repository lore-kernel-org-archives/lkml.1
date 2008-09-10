Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYIJL6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYIJL6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbYIJL6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:58:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33823 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbYIJL6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:58:05 -0400
Date: Wed, 10 Sep 2008 13:57:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD
	IOMMU's alloc_coherent
Message-ID: <20080910115751.GA4970@elte.hu>
References: <20080910201851R.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910201851R.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This is for tip/iommu.

applied these commits to tip/x86/iommu:

edee956: x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent
9821626: x86: convert dma_alloc_coherent to use is_device_dma_capable
8a493d3: x86: remove duplicated extern force_iommu

thanks!

	Ingo
