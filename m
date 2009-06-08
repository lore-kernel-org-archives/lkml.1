Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbZFHWM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbZFHWM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 18:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZFHWMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 18:12:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49627 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbZFHWMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 18:12:49 -0400
Date: Tue, 9 Jun 2009 00:12:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH v3] printk: add halt_delay parameter for printk delay
	in halt phase
Message-ID: <20090608221246.GA32209@elte.hu>
References: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com> <20090608081439.GB6372@elte.hu> <20090608012845.9c428525.akpm@linux-foundation.org> <a8e1da0906080142u62a45c47g2181a79addfb6168@mail.gmail.com> <20090608084807.GE6372@elte.hu> <20090608092607.8b331bf0.akpm@linux-foundation.org> <20090608171501.GA15399@elte.hu> <20090608143913.749e19c5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608143913.749e19c5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> Plus the feature becomes more general - perhaps there are use 
> cases where people want to slow down printks, such as: kernel goes 
> oops, data scrolls off, serial console/netconsole unavailable.  
> pause_on_oops is supposed to help here but last time I tried it, 
> it kinda didn't work, plus pause_on_oops doesn't solve the 
> data-scrolled-off problem.

btw, i solved that particular problem in one of my kernels by adding 
a pause_on_oops_head and pause_on_oops_tail hack some time ago. (It 
properly and well deservedly died an entropic death.)

So the problem space is real, and our tools for it suck to a certain 
degree. Your generalization would certainly help.

	Ingo
