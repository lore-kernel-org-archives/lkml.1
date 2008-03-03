Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbYCCR4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbYCCR4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbYCCR4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:56:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59384 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbYCCR4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:56:16 -0500
Date: Mon, 3 Mar 2008 18:55:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, torvalds@linux-foundation.org,
       hans.rosenfeld@amd.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
Message-ID: <20080303175557.GA26718@elte.hu>
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <29495f1d0803030951i151c6373oe1839705983795ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29495f1d0803030951i151c6373oe1839705983795ee@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Nish Aravamudan <nish.aravamudan@gmail.com> wrote:

> >  in any case, the commit has to be reverted as it clearly isnt a NOP 
> >  on your box as it was intended to be. (it should only have made a 
> >  difference in a rare hugetlbfs case)
> 
> On x86/{,_64}, _PAGE_PSE and _PAGE_PROTNONE are the same bit. Would 
> that have any effect here? We encountered that collision when adding 
> mprotect() support for hugepages.

well, this is the PMD, and PROTNONE is a pte property.

	Ingo
