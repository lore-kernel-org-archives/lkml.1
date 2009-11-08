Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbZKHMXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbZKHMXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZKHMW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:22:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44721 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbZKHMWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:50 -0500
Date: Sun, 8 Nov 2009 13:22:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [alpha] Add minimal support for software performance
 events.
Message-ID: <20091108122226.GC11372@elte.hu>
References: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
 <20091026084854.GA26990@elte.hu>
 <4AE6AAD3.3000102@orcon.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE6AAD3.3000102@orcon.net.nz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Cree <mcree@orcon.net.nz> wrote:

> > Should be done not by removing the stack-protector build 
> > unconditionally - but by auto-testing whether stackprotector is 
> > supported by GCC and using it if yes.
> 
> Revised patch attached.  It includes a test that the compiler doesn't 
> bomb out with -fstack-protector-all and only adds the option to CFLAGS 
> if ok.  But I have had to put the test below the definition of the 
> macro CC.  This has the side effect of separating the addition of 
> -fstack-protector-all from the main definitions of CFLAGS and 
> ALL_CFLAGS, and is not ideal in my opinion.  The patch also removes 
> -Wcast-align (I forgot to say that in the commit message of the 
> patch).

Nice, i'll queue this up for Linus.

Your S-O-B line was missing from this second patch - i presume you 
intended it to be included, right?

Thanks,

	Ingo
