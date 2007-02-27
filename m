Return-Path: <linux-kernel-owner+w=401wt.eu-S1751753AbXB0St2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbXB0St2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 13:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXB0St2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 13:49:28 -0500
Received: from brick.kernel.dk ([62.242.22.158]:23073 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbXB0St1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 13:49:27 -0500
Date: Tue, 27 Feb 2007 19:49:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Avi Kivity <avi@argo.co.il>
Cc: Ingo Molnar <mingo@elte.hu>, suparna@in.ibm.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets",  generic AIO support, v3)
Message-ID: <20070227184906.GB3733@kernel.dk>
References: <20070223151515.GA12960@in.ibm.com> <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com> <20070226135736.GF3822@kernel.dk> <20070226141315.GA15631@in.ibm.com> <20070226144548.GH3822@kernel.dk> <20070227043331.GA29942@in.ibm.com> <45E43827.4000102@argo.co.il> <20070227152507.GA8294@elte.hu> <45E45915.20204@argo.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E45915.20204@argo.co.il>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27 2007, Avi Kivity wrote:
> Ingo Molnar wrote:
> >* Avi Kivity <avi@argo.co.il> wrote:
> >
> >  
> >>But what about cpu usage?  At these low levels, the cpu is probably 
> >>underutilized.  It would be interesting to measure cpu time per I/O 
> >>request (or, alternatively, use an I/O subsystem that can saturate the 
> >>processors).
> >>    
> >
> >yeah - that's what testing on ramdisk (Jens') or on a loopback block 
> >device (mine) approximates to a certain degree.
> >
> >  
> 
> Ramdisks or fully cached loopback return immediately, so cache thrashing 
> effects don't show up.
> 
> Maybe a device mapper delay target or nbd + O_DIRECT can insert delays 
> to make the workload more disk-like.

Take a look at scsi-debug, it can do at least some of that.

-- 
Jens Axboe

