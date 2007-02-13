Return-Path: <linux-kernel-owner+w=401wt.eu-S1751351AbXBMWWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbXBMWWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXBMWWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:22:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57048 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbXBMWWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:22:49 -0500
Date: Tue, 13 Feb 2007 23:19:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070213221955.GG22104@elte.hu>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu> <20070213150019.4b4d4827@localhost.localdomain> <20070213145848.GS18311@kvack.org> <20070213165642.GB16394@elte.hu> <20070213185636.GA23987@2ka.mipt.ru> <20070213191224.GA4894@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213191224.GA4894@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> > I have not received first mail with announcement yet, so I will place 
> > my thoughts here if you do not mind.
> 
> An issue with sys_async_wait(): is is possible that events_left will 
> be setup too late so that all events are already ready and thus 
> sys_async_wait() can wait forever (or until next $sys_async_wait are 
> ready)?

yeah. I have fixed this up and have uploaded a newer queue to:

 http://redhat.com/~mingo/syslet-patches/

	Ingo
