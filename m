Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbZEGLCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbZEGLCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZEGLCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:02:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51194 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbZEGLCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:02:04 -0400
Date: Thu, 7 May 2009 13:01:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, mingo@redhat.com, airlied@linux.ie
Subject: Re: IOMMU and graphics cards
Message-ID: <20090507110135.GC28398@elte.hu>
References: <20090428160448.GA17438@amd.com> <20090507164742V.fujita.tomonori@lab.ntt.co.jp> <20090507100114.GF4059@amd.com> <20090507191724N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507191724N.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > The proprietary drivers make problems so far. For the ATI one I 
> > am in contact with the developers to try to fix it. But I can't 
> > do anything about the other proprietary driver I am aware of :-(
> 
> I don't know anything about the graphic drivers but are there any 
> other proprietary drivers except for ATI and AMD? Fixing only two 
> drivers to make the majority happy?

ATI ~== AMD these days. The problem is Nvidia cards stuck into AMD 
systems.

I guess refusing those DMA accesses (and printing something 
meaningful and relentlessly honest so that the user knows where the 
problem comes from) is the proper solution. There will be some 
end-user moaning, there might be distros turning off the IOMMU code 
summarily, but nvidia-in-AMD-box is an unfriendly alliance to begin 
with.

	Ingo
