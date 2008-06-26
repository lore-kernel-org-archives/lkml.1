Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbYFZLtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbYFZLtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbYFZLsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:48:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57383 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbYFZLsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:48:51 -0400
Date: Thu, 26 Jun 2008 13:48:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] modules: Take a shortcut for checking if an address is
	in a module
Message-ID: <20080626114834.GG29619@elte.hu>
References: <20080610130519.21bc66f3@infradead.org> <20080611081847.0b22079c@infradead.org> <200806121020.58881.rusty@rustcorp.com.au> <200806261546.58919.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806261546.58919.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thursday 12 June 2008 10:20:58 Rusty Russell wrote:
> > Or, we could actually make those as variables and update them in module.c
> > itself.  No arch changes required, and pretty easy to understand.
> 
> And since you didn't reply, here's the patch.
> 
> modules: Take a shortcut for checking if an address is in a module
> 
> This patch keeps track of the boundaries of module allocation, in
> order to speed up module_text_address().
> 
> Inspired by Arjan's version, which required arch-specific defines:

great - i've also put this into tip/out-of-tree for more testing.

	Ingo
