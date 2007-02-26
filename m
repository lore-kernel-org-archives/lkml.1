Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbXBZTrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbXBZTrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 14:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbXBZTrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 14:47:22 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4965 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbXBZTrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 14:47:21 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 26 Feb 2007 11:47:18 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070225194250.GA1353@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702261145360.1881@alien.or.mcafeemobile.com>
References: <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu>
 <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu>
 <20070222133201.GB5208@2ka.mipt.ru> <20070223115152.GA2565@elte.hu>
 <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu>
 <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu>
 <20070225194250.GA1353@2ka.mipt.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Feb 2007, Evgeniy Polyakov wrote:

> Why userspace rescheduling is in order of tens times faster than
> kernel/user?

About 50 times in my Opteron 254 actually. That's libpcl's (swapcontext 
based) cobench against lat_ctx.



- Davide


