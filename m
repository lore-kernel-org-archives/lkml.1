Return-Path: <linux-kernel-owner+w=401wt.eu-S1751450AbXBVHFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbXBVHFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 02:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXBVHFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 02:05:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58185 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbXBVHF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 02:05:29 -0500
Date: Thu, 22 Feb 2007 08:00:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070222070013.GA30921@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <f2b55d220702211704o549efd70oc0998cc663537ddd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220702211704o549efd70oc0998cc663537ddd@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael K. Edwards <medwards.linux@gmail.com> wrote:

> [...]  Unless you essentially lock one application thread to each CPU 
> core, with a complete understanding of its cache sharing and latency 
> relationships to all the other cores, and do your own userspace I/O 
> scheduling and dispatching state machine -- which is what all 
> industrial-strength databases and other sorts of transaction engines 
> currently do -- you get the same old best-effort context-thrashing 
> scheduler we've had since Solaris 2.0.

the syslet/threadlet framework has been derived from Tux, which one can 
accuse of may things, but which i definitely can not accuse of being 
slow. It has no relationship whatsoever to Solaris 2.0 or later.

Your other mail showed that you have very basic misunderstandings about 
how threadlets work, on which you based a string of firm but incorrect 
conclusions. In this discussion i'm mostly interested in specific 
feedback about syslets/threadlets - thankfully we are past the years of 
"unless Linux does generic technique X it will stay a hobby OS forever" 
type of time-wasting discussions.

	Ingo
