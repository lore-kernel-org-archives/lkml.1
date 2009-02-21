Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbZBUPXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbZBUPXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 10:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZBUPXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 10:23:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37453 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbZBUPXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 10:23:18 -0500
Date: Sat, 21 Feb 2009 16:23:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH] kmemcheck: add hooks for the page allocator
Message-ID: <20090221152310.GB6460@elte.hu>
References: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com> <1235223364-2097-5-git-send-email-vegard.nossum@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235223364-2097-5-git-send-email-vegard.nossum@gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> This adds support for tracking the initializedness of memory 
> that was allocated with the page allocator. Highmem requests 
> are not tracked.

yeah - highmem pages are also rather uninteresting, as if 
there's any uninitialized use going on we'll trigger it with 
lowmem pages too - there's no highmem-only allocations in the 
kernel.

	Ingo
