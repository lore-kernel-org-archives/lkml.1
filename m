Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbYFRKBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbYFRKBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYFRKBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:01:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46543 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbYFRKBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:01:00 -0400
Date: Wed, 18 Jun 2008 12:00:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] modules: Take a shortcut for checking if an address is
	in a module
Message-ID: <20080618100041.GD15255@elte.hu>
References: <20080610130519.21bc66f3@infradead.org> <200806112112.08623.rusty@rustcorp.com.au> <20080611081847.0b22079c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611081847.0b22079c@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> > Nothing wrong with the idea, but how about a nice 
> > arch_maybe_module_addr() macro rather than ifdefs in module.c?
> 
> Everytime someone says that, I go crawl under my desk and weep quietly 
> for 10 minutes.

i've added your patch for testing purposes to tip/out-of-tree.

(An updated patch with the module.h change suggested by Rusty, as long 
as acked by Rusty could go into tip/core/locking and thus show up in 
linux-next as well.)

	Ingo
