Return-Path: <linux-kernel-owner+w=401wt.eu-S965115AbXCAOf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115AbXCAOf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965122AbXCAOf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:35:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46333 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965115AbXCAOfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:35:24 -0500
Date: Thu, 1 Mar 2007 15:27:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301142756.GA22076@elte.hu>
References: <20070301095402.GA14603@elte.hu> <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu> <200703011531.12818.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703011531.12818.dada1@cosmosbay.com>
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


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> On my machines (again ...), ab is the slow thing... not the 'server'

Evgeniy said that both in the epoll and the kevent case the server side 
CPU was 98%-100% busy - so inefficiencies on the client side do not 
matter that much - the server is saturated. It's that "kevent is 25% 
faster than epoll" claim that i'm probing mainly.

	Ingo
