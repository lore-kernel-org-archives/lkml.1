Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbXCAOT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbXCAOT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbXCAOT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:19:29 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:56959 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbXCAOT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:19:28 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Thu, 1 Mar 2007 15:19:19 +0100
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
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu> <20070301133018.GB30177@2ka.mipt.ru>
In-Reply-To: <20070301133018.GB30177@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011519.20001.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007 14:30, Evgeniy Polyakov wrote:
> On Thu, Mar 01, 2007 at 02:11:18PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > ok?
>
> I undesrtood you couple of mails ago.
> No problem, I can put processing into the same function called from
> different servers :)
>
> > Btw., am i correct that in this particular 'ab' test, the 'immediately'
> > flag is always zero, i.e. kweb_kevent_remove() is always called?
>
> Yes.
>
> > 	Ingo

I can tell you that the problem (at least on my machine) comes from :

gettimeofday(&tm, NULL);

in evserver_epoll.c


