Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbXB1IpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbXB1IpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 03:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbXB1IpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 03:45:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34519 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbXB1IpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 03:45:06 -0500
Date: Wed, 28 Feb 2007 09:38:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3)
Message-ID: <20070228083805.GB9705@elte.hu>
References: <20070223151515.GA12960@in.ibm.com> <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com> <20070226135736.GF3822@kernel.dk> <20070226141315.GA15631@in.ibm.com> <20070226144548.GH3822@kernel.dk> <20070227043331.GA29942@in.ibm.com> <20070227094211.GR3822@kernel.dk> <20070227123932.GA8720@in.ibm.com> <20070228083100.GM3733@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228083100.GM3733@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> Engine                Depth      Batch	Bw (KiB/sec)
> libaio		20000	   8		21,125
> syslet		20000	   8		19,610

i'd like to do something more about this to be more in line with libaio 
- if nothing else then for the bragging rights ;-) It seems to me that a 
drop of ~7% in throughput cannot be explained with any CPU overhead, it 
must be some sort of queueing + IO scheduling effect - right?

	Ingo
