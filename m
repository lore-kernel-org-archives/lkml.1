Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYKKOUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYKKOUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:20:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbYKKOTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:19:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49132 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbYKKOTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:19:52 -0500
Date: Tue, 11 Nov 2008 15:19:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081111141942.GA7079@elte.hu>
References: <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu> <20081107082003.GA15800@x200.localdomain> <20081107083249.GD4435@elte.hu> <20081107084943.GA16147@x200.localdomain> <20081107085352.GA27245@elte.hu> <20081107090304.GA30540@elte.hu> <20081111122531.GA5836@joi> <20081111132018.GI14989@elte.hu> <18713.37039.130384.255448@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18713.37039.130384.255448@harpo.it.uu.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> Ingo Molnar writes:
>  > > >  # cat /proc/18579/stack
>  > > >  [<ffffffffffffffff>] 0xffffffffffffffff
>  > > 
>  > > so this file provides view of _kernel_ stack only?
>  > > shouldn't it be named kernel-stack then?
>  > 
>  > it prints the kernel stack right now, but i'd not restrict it to 
>  > the kernel stack conceptually: i think we could eventually expand 
>  > it to print the user-space portion of the stack as well. (in the 
>  > case when user-space is built with frame pointers) We've got code 
>  > for that in the kernel already. It would be an easy one-stop-shop 
>  > for full-range.
> 
> That would be quite fragile given the fact that user-space only has 
> to follow standard ABIs at specific points like calls to standard 
> library functions. In between, anything can, and does, happen.

it's not fragile to robustly walk the userspace stack. The result 
might not always be meaningful of course.

	Ingo
