Return-Path: <linux-kernel-owner+w=401wt.eu-S1750967AbXBXMSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967AbXBXMSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 07:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXBXMSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 07:18:35 -0500
Received: from brick.kernel.dk ([62.242.22.158]:17567 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbXBXMSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 07:18:34 -0500
Date: Sat, 24 Feb 2007 13:18:16 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3)
Message-ID: <20070224121816.GF22586@kernel.dk>
References: <20070221211355.GA7302@elte.hu> <20070223125247.GO5737@kernel.dk> <20070223223112.GJ7920@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223223112.GJ7920@ca-server1.us.oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23 2007, Joel Becker wrote:
> On Fri, Feb 23, 2007 at 01:52:47PM +0100, Jens Axboe wrote:
> > Results:
> > 
> > Engine          Depth           Bw (MiB/sec)
> > --------------------------------------------
> > libaio            1             441
> > syslet            1             574
> > sync              1             589
> > libaio           32             613
> > syslet           32             681
> 
> 	Can we get runs with large I/Os, large I/O depths, and most
> importantly tons of processes?  I can absolutely believe that syslets
> would compete well with one process on the system.  But with 1000
> processes doing 1000s of blocking I/Os, I'd really be interested to see
> how that plays out.

Sure, I'll add this to the testing list for monday.

-- 
Jens Axboe

