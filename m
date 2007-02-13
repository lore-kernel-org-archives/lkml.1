Return-Path: <linux-kernel-owner+w=401wt.eu-S1751740AbXBMTPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbXBMTPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXBMTPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:15:08 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:57219 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbXBMTPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:15:01 -0500
Date: Tue, 13 Feb 2007 22:12:24 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20070213191224.GA4894@2ka.mipt.ru>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu> <20070213150019.4b4d4827@localhost.localdomain> <20070213145848.GS18311@kvack.org> <20070213165642.GB16394@elte.hu> <20070213185636.GA23987@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070213185636.GA23987@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Tue, 13 Feb 2007 22:12:35 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I have not received first mail with announcement yet, so I will place 
> my thoughts here if you do not mind.

An issue with sys_async_wait():
is is possible that events_left will be setup too late so that all
events are already ready and thus sys_async_wait() can wait forever
(or until next $sys_async_wait are ready)?

-- 
	Evgeniy Polyakov
