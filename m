Return-Path: <linux-kernel-owner+w=401wt.eu-S2992667AbXCBRcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992667AbXCBRcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992669AbXCBRcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:32:48 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3076 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992667AbXCBRcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:32:47 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 2 Mar 2007 09:32:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Eric Dumazet <dada1@cosmosbay.com>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070302105713.GB15576@elte.hu>
Message-ID: <Pine.LNX.4.64.0703020928580.1977@alien.or.mcafeemobile.com>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu>
 <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com>
 <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru>
 <20070301150942.GA26025@elte.hu> <20070301153655.GB8217@2ka.mipt.ru>
 <20070302105713.GB15576@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Ingo Molnar wrote:

> > After your changes epoll increased to 5k.
> 
> Can we please stop this pointless episode of benchmarketing, where every 
> mail of yours shows different results and you even deny having said 
> something which you clearly said just a few days ago? At this point i 
> simply cannot trust the numbers you are posting, nor is the discussion 
> style you are following productive in any way in my opinion.

Agreed. Can we focus on the topic here? We're still missing proper FPU 
context switch in the move_user_context(). In v6?


- Davide


