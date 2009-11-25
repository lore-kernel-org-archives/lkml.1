Return-Path: <linux-kernel-owner+w=401wt.eu-S934629AbZKYJKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934629AbZKYJKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934597AbZKYJK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:10:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45690 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934585AbZKYJK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:10:28 -0500
Date: Wed, 25 Nov 2009 10:10:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
Message-ID: <20091125091026.GA11117@elte.hu>
References: <4B0C7257.3070609@kernel.org>
 <20091125081832.GA1822@elte.hu>
 <4B0CF0CA.30807@kernel.org>
 <20091125180517P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125180517P.fujita.tomonori@lab.ntt.co.jp>
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

> On Wed, 25 Nov 2009 00:54:34 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > only remember that SLES 9 SP3 (?) at some point has problem with AMD 
> > 10h ( quad core version) when memory > 4 g (with USB controller ?) 
> > because the gart code only check K8 device id, and didn't check 10h 
> > device id. so gart iommu is not used. and happenly swiotlb code has 
> > problem with that kernel version.
> > 
> > thinking we should keep old behavior, until some day we can remove 
> > them all.
> 
> Why? We are talking about changing 2.6.33 behavior. swiotlb in 2.6.33 
> should be the safe option.

If that behavior was relied on for suspected (or real) bugs in the 
swiotlb code then i agree that we should do this change. (and fix any 
bugs if they still occur.)

	Ingo
