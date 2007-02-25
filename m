Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbXBYQgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbXBYQgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 11:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbXBYQgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 11:36:20 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:36070 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXBYQgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 11:36:19 -0500
Date: Sun, 25 Feb 2007 18:24:27 +0300
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
Subject: Re: Threadlet/syslet v4 bug report.
Message-ID: <20070225152426.GA27316@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <20070225143310.GA12456@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070225143310.GA12456@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sun, 25 Feb 2007 19:33:36 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 05:33:10PM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> Hi Ingo.
> 
> I tried to create web server application for threadlets to show (will
> not write what I wanted to show, but you might guess :)
> 
> I started threadlet-test from async-test-v4 and got following bug.
> 
> To compile v4 and v3 I need to apply a patch (sent in previous e-mail),
> which removes %xgs assignment since it is never used and actually does
> not even exist it pt_regs.

If I uncomment xgs and recompile - kernel crashes early on init...

Btw, could you create a git tree to pull from?
That would be much easier to track problems and to test for others.

-- 
	Evgeniy Polyakov
