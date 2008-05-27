Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYE0IE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYE0IE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbYE0IEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:04:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55827 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbYE0IEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:04:10 -0400
Date: Tue, 27 May 2008 10:03:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: Andi Kleen <andi@firstfloor.org>, Glauber Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of
	__GFP_NORETRY
Message-ID: <20080527080349.GE29246@elte.hu>
References: <20080526234940.GA1376@xs4all.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526234940.GA1376@xs4all.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0079]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miquel van Smoorenburg <mikevs@xs4all.net> wrote:

> Please consider the below patch for 2.6.26 (can somebody from the x86 
> team pick this up please? Thank you)

looks good to me in principle - but it should go via -mm as it touches 
mm/page_alloc.c. Andrew: this fix is for v2.6.26.

	Ingo
