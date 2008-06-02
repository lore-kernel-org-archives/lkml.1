Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYFBSo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYFBSo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYFBSoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:44:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50301 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYFBSoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:44:18 -0400
Date: Mon, 2 Jun 2008 20:43:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org, x86@kernel.org
Subject: Re: [PATCH 3/3] 64-bit futexes: x86 support
Message-ID: <20080602184320.GA4081@elte.hu>
References: <200805310127.m4V1RLdP013819@devserv.devel.redhat.com> <20080602082226.GA2450@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602082226.GA2450@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > This patch adds 64-bit futex support for x86.  As explained in the 
> > introduction, this requires a new system call.  The remaining 
> > changes are similarly to the x86-64 changes: enable support for 
> > FUTEX_WAKE_OP.
> 
> great work - the first two patches look good and we've created a new 
> -tip topic branch for it, tip/core/futex-64bit.

the topic is not yet offered for linux-next though, until the API 
discussion with Linus is resolved one way or another :-)

	Ingo
