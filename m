Return-Path: <linux-kernel-owner+w=401wt.eu-S1751012AbXB0NRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751012AbXB0NRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 08:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXB0NRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 08:17:05 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:41098 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbXB0NRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 08:17:04 -0500
Date: Tue, 27 Feb 2007 16:14:29 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Theodore Tso <tytso@mit.edu>,
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
Message-ID: <20070227131427.GA29798@2ka.mipt.ru>
References: <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org> <20070227123421.GA21616@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070227123421.GA21616@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 27 Feb 2007 16:16:11 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 01:34:21PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> based servers. The measurements so far have shown that the absolute 
> worst-case threading server performance is at around 60% of that of 
> non-context-switching servers - and even that level is reached 
> gradually, leaving time for action for the server owner. While with 
> fully event based servers there are mostly only two modes of 
> performance: 100% performance and near-0% performance: total breakdown.

Let's live in piece! :) 
I always agreed that they should be used together - event-based rings 
of IO requests, if request happens to block (which should be avaided 
as much as possible), then it continues on behalf of sleeping thread.

> 	Ingo

-- 
	Evgeniy Polyakov
