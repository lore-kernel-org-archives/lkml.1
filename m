Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbYAIE2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbYAIE2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYAIE2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:28:18 -0500
Received: from ozlabs.org ([203.10.76.45]:37478 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbYAIE2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:28:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
Date: Wed, 9 Jan 2008 15:27:59 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: mingo@elte.hu, kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
References: <20080108063113.GA21287@fattire.cabal.ca> <200801091420.19273.rusty@rustcorp.com.au> <20080108193350.ffc94e44.akpm@linux-foundation.org>
In-Reply-To: <20080108193350.ffc94e44.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801091528.00402.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008 14:33:50 Andrew Morton wrote:
> On Wed, 9 Jan 2008 14:20:18 +1100 Rusty Russell <rusty@rustcorp.com.au> 
wrote:
> > On Wednesday 09 January 2008 11:21:59 Andrew Morton wrote:
> > > The string handling in here has become a bit scruffy.
> >
> > Yes, that patch also evokes a const warning.  Fixed below.
>
> No patch was included.

Yes, I decided it's a secret.  Mine, all mine!

> >  I assume you've
> > queued these because you're thinking of applying them before 2.6.24?  I'd
> > say only
> > modules-de-mutex-more-symbol-lookup-paths-in-the-module-code.patch
> > warrants that (the other is unlikely and not a regression).
>
> Actually I was thinking 2.6.25 on both.

Then, you should get them next time you grab my series, no?  Or is that 
particular lever not working yet?

Hmm, I see my link was not updated (damn, ln -sfn, not ln -sf!).  Fixed now:
	http://ozlabs.org/~rusty/kernel/rr-latest/

More goodies there than a UK comedy convention...

> OK, 2.6.24 seems reasonable.

Kyle acked it at least...

> Yes, it could all do with a revisit.

And it goes without saying that glory awaits they who succeed...
Rusty.
