Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYDIPBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYDIPBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYDIPBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:01:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40382 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbYDIPBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:01:14 -0400
Date: Wed, 9 Apr 2008 16:59:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Mayer <ajm@sgi.com>
Cc: torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
Message-ID: <20080409145945.GB17100@elte.hu>
References: <Pine.SGI.3.96.1080408160826.8706317D-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SGI.3.96.1080408160826.8706317D-100000@fergus.americas.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0108]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Mayer <ajm@sgi.com> wrote:

> Subject: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
> 
> From: Alan Mayer <ajm@sgi.com>
> 
> The SGI UV system needs several more system vectors than a vanilla 
> x86_64 system.  Rather than burden the other archs with extra system 
> vectors that they don't use, change FIRST_SYSTEM_VECTOR to a variable, 
> so that it can be dynamic.

nice - but please split this up into two patches: first one that changes 
the generic code to use a variable limit - this patch will (should) be a 
functional NOP.

then a second patch adds those two new UV vectors.

Also, could you please also change the 32-bit side as well so that we at 
least keep the two implementations roughly in sync?

	Ingo
