Return-Path: <linux-kernel-owner+w=401wt.eu-S1751292AbXB1QLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbXB1QLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXB1QLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:11:55 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1399 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751292AbXB1QLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:11:54 -0500
Date: Tue, 27 Feb 2007 17:13:44 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070227171343.GA3956@ucw.cz>
References: <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu> <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu> <20070225194250.GA1353@2ka.mipt.ru> <20070226123922.GA1370@elte.hu> <20070226140500.GA31629@2ka.mipt.ru> <20070226141518.GA24683@elte.hu> <20070226165513.GB22454@2ka.mipt.ru> <20070226203543.GB23357@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226203543.GB23357@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If kernelspace rescheduling is that fast, then please explain me why 
> > userspace one always beats kernel/userspace?
> 
> because 'user space scheduling' makes no sense? I explained my thinking 
> about that in a past mail:
...
>  2) there has been an IO event. The thing is, for IO events we enter the
>     kernel no matter what - and we'll do so for the next 10 years at

..actually, at some point 3D acceleration was done by accessing hw
directly from userspace. OTOH I think we are moving away from that
model, so it is probably irrelevant here.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
