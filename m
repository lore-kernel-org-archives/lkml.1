Return-Path: <linux-kernel-owner+w=401wt.eu-S1030742AbXBOT0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030742AbXBOT0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030750AbXBOT0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:26:18 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:60877 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030742AbXBOT0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:26:17 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: bert hubert <bert.hubert@netherlabs.nl>
Subject: Re: [patch 05/11] syslets: core code
Date: Thu, 15 Feb 2007 20:26:08 +0100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org> <20070215184656.GA12897@outpost.ds9a.nl>
In-Reply-To: <20070215184656.GA12897@outpost.ds9a.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702152026.08541.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 19:46, bert hubert wrote:

> Both 1 and 2 are currently limiting factors when I enter the 100kqps domain
> of name serving. This doesn't mean the rest of my code is as tight as it
> could be, but I spend a significant portion of time in the kernel even at
> moderate (10kqps effective) loads, even though I already use epoll. A busy
> PowerDNS recursor typically spends 25% to 50% of its time on 'sy' load.

Well, I guess in your workload most of system overhead is because of sockets 
creation/destruction, UDP/IP stack work, nic driver, interrupts... I really 
doubt async_io could help you... Do you have some oprofile results to share 
with us ?
