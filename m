Return-Path: <linux-kernel-owner+w=401wt.eu-S1751243AbXBZKmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbXBZKmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXBZKmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:42:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55166 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXBZKme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:42:34 -0500
Date: Mon, 26 Feb 2007 11:35:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070226103517.GA17195@elte.hu>
References: <20070225182230.GA3622@elte.hu> <20070225183743.GD29821@2ka.mipt.ru> <20070225192112.GA15681@elte.hu> <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu> <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com> <20070226081655.GA25280@elte.hu> <20070226092545.GA4110@2ka.mipt.ru> <20070226095547.GA9485@elte.hu> <20070226103319.GA24284@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226103319.GA24284@2ka.mipt.ru>
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


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> Btw, 'evserver' in the name means 'event server', so you might think 
> about changing the name :)

why should i change the name? The 'outer' loop, which feeds requests to 
threadlets, is an epoll based event loop. The inner loop, where all the 
application complexity resides, is a threadlet. This is the "more 
intelligent queueing" model i talked about in my reply to David 4 days 
ago:

  http://lkml.org/lkml/2007/2/22/180
  http://lkml.org/lkml/2007/2/22/191

	Ingo
