Return-Path: <linux-kernel-owner+w=401wt.eu-S1161201AbXBZVkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161201AbXBZVkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161215AbXBZVkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:40:33 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1413 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161201AbXBZVkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:40:32 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 26 Feb 2007 13:40:29 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Suparna Bhattacharya <suparna@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets",
 generic AIO support, v3)
In-Reply-To: <20070226135736.GF3822@kernel.dk>
Message-ID: <Pine.LNX.4.64.0702261338050.1881@alien.or.mcafeemobile.com>
References: <20070221211355.GA7302@elte.hu> <20070223125247.GO5737@kernel.dk>
 <20070223135525.GA31569@in.ibm.com> <20070223145826.GA32465@elte.hu>
 <20070223151515.GA12960@in.ibm.com> <20070223162508.GA16782@kernel.dk>
 <20070223171348.GA27838@in.ibm.com> <20070226135736.GF3822@kernel.dk>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Jens Axboe wrote:

> 
> Some more results, using a larger number of processes and io depths. A
> repeat of the tests from friday, with added depth 20000 for syslet and
> libaio:
> 
> Engine          Depth   Processes       Bw (MiB/sec)
> ----------------------------------------------------
> libaio            1         1            602
> syslet            1         1            759
> sync              1         1            776
> libaio           32         1            832
> syslet           32         1            898
> libaio        20000         1            581
> syslet        20000         1            609

That looks great! IMO there may be a little higher cost associated with 
the syslets thread switches, that we currently do not perform 100% 
cleanly, but results look nevertheless awesome.



- Davide


