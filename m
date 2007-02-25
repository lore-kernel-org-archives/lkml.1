Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbXBYSdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbXBYSdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 13:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933700AbXBYSdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 13:33:37 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43192 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933001AbXBYSdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 13:33:36 -0500
Date: Sun, 25 Feb 2007 21:25:55 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070225182555.GC29821@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <20070224183421.GA6835@2ka.mipt.ru> <20070225172337.GB4998@elte.hu> <20070225174438.GA13647@2ka.mipt.ru> <20070225175437.GA9480@elte.hu> <20070225182135.GB29821@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070225182135.GB29821@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sun, 25 Feb 2007 21:26:49 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 09:21:35PM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> > Do you have any link where i could check the type of HTTP parsing and 
> > send transport you are (or will be) using? What type of http client are 
> > you using to measure, with precisely what options?
> 
> For example this ones (essentially the same, except that epoll and
> kevent are used):
> http://tservice.net.ru/~s0mbre/archive/kevent/evserver_kevent.c
> http://tservice.net.ru/~s0mbre/archive/kevent/evserver_epoll.c

Client is 'ab' with high number of connections and concurrency.
For example for athlon64 3500 I used concurrency of 8000 connections 
and 80k total.

-- 
	Evgeniy Polyakov
