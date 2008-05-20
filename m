Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYETMJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYETMJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757873AbYETMJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:09:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38573 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757368AbYETMJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:09:19 -0400
Date: Tue, 20 May 2008 14:08:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 0/2] panics booting NUMA SPARSEMEM on x86_32 NUMA
Message-ID: <20080520120855.GA10080@elte.hu>
References: <exportbomb.1211277639@pinky>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <exportbomb.1211277639@pinky>
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


* Andy Whitcroft <apw@shadowen.org> wrote:

> We have been seeing panics booting NUMA SPARSEMEM kernels on x86_32 
> hardware, while trying to allocate node local memory in early boot. 
> These are caused by a miss-allocation of the node pgdat structures 
> when numa remap is disabled.
> 
> Following this email are two patches, the first reenables numa remap 
> for SPARSEMEM as the underlying bug has now been fixed.  The second 
> hardens the pgdat allocation in the face of there being no numa remap 
> for a particular node (which may still occur).

applied to -tip, thanks Andy.

	Ingo
