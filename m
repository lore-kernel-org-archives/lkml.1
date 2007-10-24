Return-Path: <linux-kernel-owner+w=401wt.eu-S1765555AbXJXRBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765555AbXJXRBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759946AbXJXQvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:51:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56428 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763463AbXJXQvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:51:04 -0400
Date: Wed, 24 Oct 2007 18:50:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make kernel/sched.c:account_guest_time() static
Message-ID: <20071024165027.GA32682@elte.hu>
References: <20071024162517.GW30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024162517.GW30533@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> account_guest_time() can become static.

thanks, applied.

btw., how about adding your 'check static functions' scripts to the 
kernel, via a "make checkstatic" pass or something like that? That way 
people could check this for themselves and could avoid letting them into 
the kernel.

	Ingo
