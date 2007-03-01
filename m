Return-Path: <linux-kernel-owner+w=401wt.eu-S933215AbXCAJ34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbXCAJ34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933217AbXCAJ34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:29:56 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49017 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933215AbXCAJ3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:29:55 -0500
Date: Thu, 1 Mar 2007 12:28:05 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301092805.GI7217@2ka.mipt.ru>
References: <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com> <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702280836080.12485@woody.linux-foundation.org> <Pine.LNX.4.64.0702281011220.6806@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702281040030.12485@woody.linux-foundation.org> <Pine.LNX.4.64.0702281047430.6806@alien.or.mcafeemobile.com> <45E5D217.9060101@nortel.com> <Pine.LNX.4.64.0702281134380.6806@alien.or.mcafeemobile.com> <20070301083806.GF7217@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070301083806.GF7217@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 12:28:34 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 11:38:06AM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> > struct async_syscall {
> > 	long *result;
> > 	unsigned long asynid;
> > 	unsigned long nr_sysc;
> > 	unsigned long params[8];
> > };
> 
> Having result pointer as NULL might imply that result is not interested
> in and thus it can be discarded and event async syscall will not be
> returned through aync_wait().
> More flexible is having request flags field in the structure.

Ugh, that is alrasdy implemented in v5.

-- 
	Evgeniy Polyakov
