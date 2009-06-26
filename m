Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZFZG7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZFZG7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 02:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbZFZG7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 02:59:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44402 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZFZG7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 02:59:38 -0400
Date: Fri, 26 Jun 2009 08:59:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: kmemleak suggestion (long message)
Message-ID: <20090626065923.GA14078@elte.hu>
References: <20090625221816.GA3480@localdomain.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625221816.GA3480@localdomain.by>
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


* Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:

> Hello.
> 
> Currently kmemleak prints info about all objects. I guess 
> sometimes kmemleak gives you more than you actually need.

It prints _a lot_ of info and spams the syslog. I lost crash info a 
few days ago due to that: by the time i inspected a crashed machine 
the tons of kmemleak output scrolled out the crash from the dmesg 
buffer.

This is not acceptable.

Instead it should perhaps print _at most_ a single line every few 
minutes, printing a summary about _how many_ leaked entries it 
suspects, and should offer a /debug/mm/kmemleak style of file where 
the entries can be read out from.

Ok?

	Ingo
