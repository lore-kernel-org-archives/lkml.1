Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbZKXP04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbZKXP04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933370AbZKXP0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:26:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44359 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933357AbZKXP0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:26:54 -0500
Date: Tue, 24 Nov 2009 16:26:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: yinghai@kernel.org, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix gart iommu using for amd 64 bit system
Message-ID: <20091124152645.GD21821@elte.hu>
References: <4B0BAC06.1000905@kernel.org>
 <20091124193031P.fujita.tomonori@lab.ntt.co.jp>
 <4B0BB892.9080401@kernel.org>
 <20091124225000H.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124225000H.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > don't think user will like to use SWIOTLB instead of swiotlb.
> 
> I doubt that users care about a way to fix their problems.

As far as swiotlb vs. GART goes, arguably a non-bouncing hw based 
solution (GART) is superior to a bouncing one (swiotlb), right?

	ngo
