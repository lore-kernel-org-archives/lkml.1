Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbXKTVJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbXKTVJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763498AbXKTVIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:08:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763445AbXKTVIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:08:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] kill PT_PTRACED
In-Reply-To: Oleg Nesterov's message of  Tuesday, 20 November 2007 18:21:33 +0300 <20071120152133.GA4546@tv-sign.ru>
References: <20071120152133.GA4546@tv-sign.ru>
Emacs: a Lisp interpreter masquerading as ... a Lisp interpreter!
Message-Id: <20071120210840.94CB726F8BE@magilla.localdomain>
Date: Tue, 20 Nov 2007 13:08:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject should be "kill PT_ATTACHED".

> -	    (!(child->ptrace & PT_ATTACHED) || child->real_parent != current)
> -	    && child->signal != NULL) {
> +	     child->sighand != NULL) {

This does s/signal/sighand/ without comment.

Otherwise the main thrust of the patch seems fine to me.


Thanks,
Roland
