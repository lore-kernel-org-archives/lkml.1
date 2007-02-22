Return-Path: <linux-kernel-owner+w=401wt.eu-S1751831AbXBVUNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbXBVUNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbXBVUNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:13:33 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4768 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbXBVUNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:13:32 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 22 Feb 2007 12:13:27 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: David Miller <davem@davemloft.net>
cc: Ingo Molnar <mingo@elte.hu>, johnpol@2ka.mipt.ru,
       Arjan Van de Ven <arjan@infradead.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hch@infradead.org,
       akpm@zip.com.au, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       zach.brown@oracle.com, suparna@in.ibm.com, jens.axboe@oracle.com,
       tglx@linutronix.de
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070222.064704.71093028.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0702221210170.1356@alien.or.mcafeemobile.com>
References: <20070222123929.GA5208@2ka.mipt.ru> <20070222.054127.104035694.davem@davemloft.net>
 <20070222143145.GA3246@elte.hu> <20070222.064704.71093028.davem@davemloft.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, David Miller wrote:

> The more I think about it, a reasonable solution might actually be to
> use threadlets for disk I/O and pure event based processing for
> networking.  It is two different handling paths and non-unified,
> but that might be the price for good performance :-)

Well, it takes 20 lines of userspace C code to bring *unification* to the 
universe ;)


- Davide


