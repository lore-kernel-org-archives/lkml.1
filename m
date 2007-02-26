Return-Path: <linux-kernel-owner+w=401wt.eu-S1030341AbXBZT1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030341AbXBZT1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 14:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030406AbXBZT1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 14:27:11 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44266 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030341AbXBZT1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 14:27:09 -0500
Date: Mon, 26 Feb 2007 22:20:02 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070226192001.GA17892@2ka.mipt.ru>
References: <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226131133.GA11777@elte.hu> <20070226173701.GD22454@2ka.mipt.ru> <1172513950.3280.388.camel@laptopd505.fenrus.org> <20070226183856.GF22454@2ka.mipt.ru> <45E32D61.7060403@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <45E32D61.7060403@nortel.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Mon, 26 Feb 2007 22:22:48 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 12:56:33PM -0600, Chris Friesen (cfriesen@nortel.com) wrote:
> Evgeniy Polyakov wrote:
> 
> >I never ever tried to say _everything_ must be driven by events.
> >IO must be driven, it is a must IMO.
> 
> Do you disagree with Linus' post about the difficulty of treating 
> open(), fstat(), page faults, etc. as events?  Or do you not consider 
> them to be IO?

>From practical point of view - yes some of that processes are complex
enough to not attract attention as async usage model.

But I'm absolutely for the scenario, when several operations are 
performed asynchronously like open+stat+fadvice+sendfile.

By IO I meant something which has end result, and that result must be
enough to start async processing - data in the buffer for example.
Async open I would combine with actual data processing - that one can be
a one event.

> Chris

-- 
	Evgeniy Polyakov
