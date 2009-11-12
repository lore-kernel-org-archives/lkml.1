Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbZKLHrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbZKLHrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbZKLHrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:47:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35936 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbZKLHrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:47:52 -0500
Date: Thu, 12 Nov 2009 08:47:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org, wmw2@infradead.org,
       joerg.roedel@amd.com, muli@il.ibm.com, hannes@cmpxchg.org,
       tj@kernel.org
Subject: Re: [PATCH -v2 6/9] bootmem: add free_bootmem_late
Message-ID: <20091112074711.GB16434@elte.hu>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1257849980-22640-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <20091111155644.196ce5c7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111155644.196ce5c7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 10 Nov 2009 19:46:17 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > Add a new function for freeing bootmem after the bootmem allocator has
> > been released and the unreserved pages given to the page allocator.
> > This allows us to reserve bootmem and then release it if we later
> > discover it was not needed.
> 
> OK, but the new function has no callers and curious people will be
> wondering what happened to patches 1, 2, 3, 4, 5, 7, 8 and 9!

They were posted to lkml alongside patch 6 - see this thread on lkml:

 [PATCH v2 0/9] x86: handle HW IOMMU initialization failure gracefully

	Ingo
