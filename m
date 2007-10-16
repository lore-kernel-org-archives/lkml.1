Return-Path: <linux-kernel-owner+w=401wt.eu-S1765631AbXJPJKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765631AbXJPJKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759454AbXJPJK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:10:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39371 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759603AbXJPJK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:10:27 -0400
Date: Tue, 16 Oct 2007 11:10:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] 2.6.23-git8 kernel oops at __rb_rotate_left+0x7/0x70
Message-ID: <20071016091012.GB24341@elte.hu>
References: <47144B4F.3050108@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47144B4F.3050108@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0324]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> While running kernbench with the 2.6.23-git8 following oops is 
> produced
> 
> Unable to handle kernel NULL pointer dereference at 0000000000000010 RIP: 
>  [<ffffffff8033f347>] __rb_rotate_left+0x7/0x70

that looks nasty ...

and -git8 should have the v2.6.23 scheduler code in essence.

	Ingo
