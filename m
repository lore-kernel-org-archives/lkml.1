Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbXE3H0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbXE3H0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbXE3H0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:26:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52031 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbXE3H0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:26:41 -0400
Date: Wed, 30 May 2007 09:26:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zach Brown <zach.brown@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530072617.GB3077@elte.hu>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070529230931.GL7875@mami.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529230931.GL7875@mami.zabbo.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zach Brown <zach.brown@oracle.com> wrote:

> > Having async request and response rings would be quite useful, and 
> > most closely match what is going on under the hood in the kernel and 
> > hardware.
> 
> Yeah, but I have lots of competing thoughts about this.

note that async request and response rings are implemented already in 
essence: that's how FIO uses syslets. The linked list of syslet atoms is 
the 'request ring' (it's just that 'ring' is not a hard-enforced data 
structure - you can use other request formats too), and the completion 
ring is the 'response ring'.

	Ingo
