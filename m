Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbXCALOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbXCALOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933243AbXCALOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:14:54 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:54427 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933235AbXCALOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:14:53 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Thu, 1 Mar 2007 12:14:44 +0100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
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
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru>
In-Reply-To: <20070301105928.GA15709@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011214.45144.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007 11:59, Evgeniy Polyakov wrote:

> Yes, it is about 98-100% in both cases.
> I've just re-run tests on my amd64 test machine without debug options:
>
> epoll		4794.23
> kevent		6468.95
>

It would be valuable if you could post oprofile results (CPU_CLK_UNHALTED) for 
both tests.

Thank you
