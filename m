Return-Path: <linux-kernel-owner+w=401wt.eu-S1161242AbXCNMtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161242AbXCNMtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161252AbXCNMtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:49:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52005 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161242AbXCNMtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:49:32 -0400
Date: Wed, 14 Mar 2007 13:49:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [RFC/PATCH 00/59] Make common x86 arch area for i386 and x86_64
Message-ID: <20070314124906.GA11966@elte.hu>
References: <1173820919.28042.3.camel@localhost.localdomain> <Pine.LNX.4.64.0703131432400.9690@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703131432400.9690@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> We've started to notice that the i386 build gets broken now that most 
> developers tend to have newer CPU's and run mostly on x86-64 (and yes, 
> that's me too), and while I don't think unifying things will guarantee 
> that doesn't happen in the future, it will hopefully at least help 
> make it not get much *worse*.

actually, even for 'cutting edge' testers, the number of 32-bit x86 
systems outnumber the number of 64-bit test-systems by a factor of 5. 
For distributions with real users, the ratio is closer to 1:10...

so i typically get bugs reported on 32-bit first, and for 64-bit it is 
usually only reported if the bug is 64-bit /only/. That basic property 
is true for both upstream, -rt and rawhide kernels.

Andi's x86 merge tree /does/ break quite often on 32-bit, but that's not 
really due to testers, that's due to Andi being primarily the 64-bit 
maintainer ;)

	Ingo
