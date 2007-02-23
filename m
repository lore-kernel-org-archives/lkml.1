Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbXBWWca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbXBWWca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 17:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933247AbXBWWca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 17:32:30 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:60383 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256AbXBWWc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 17:32:29 -0500
Date: Fri, 23 Feb 2007 14:31:12 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
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
Message-ID: <20070223223112.GJ7920@ca-server1.us.oracle.com>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@zip.com.au>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ulrich Drepper <drepper@redhat.com>,
	Zach Brown <zach.brown@oracle.com>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Davide Libenzi <davidel@xmailserver.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20070221211355.GA7302@elte.hu> <20070223125247.GO5737@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223125247.GO5737@kernel.dk>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 01:52:47PM +0100, Jens Axboe wrote:
> Results:
> 
> Engine          Depth           Bw (MiB/sec)
> --------------------------------------------
> libaio            1             441
> syslet            1             574
> sync              1             589
> libaio           32             613
> syslet           32             681

	Can we get runs with large I/Os, large I/O depths, and most
importantly tons of processes?  I can absolutely believe that syslets
would compete well with one process on the system.  But with 1000
processes doing 1000s of blocking I/Os, I'd really be interested to see
how that plays out.

Joel

-- 

 Joel's Second Law:

	If a code change requires additional user setup, it is wrong.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
