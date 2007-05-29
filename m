Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475AbXE2VvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbXE2VvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbXE2VvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:51:09 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413AbXE2VvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:51:08 -0400
Date: Tue, 29 May 2007 14:49:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
In-Reply-To: <20070529212718.GH7875@mami.zabbo.net>
Message-ID: <alpine.LFD.0.98.0705291447440.26602@woody.linux-foundation.org>
References: <20070529212718.GH7875@mami.zabbo.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 May 2007, Zach Brown wrote:
> 
> Included in this patch series is an experimental patch which reworks fs/aio.c
> to reuse the syslet subsystem to process iocb requests from user space.  The
> intent of this work is to simplify the code and broaden aio functionality.  

.. so don't keep us in suspense. Do you have any numbers for anything 
(like Oracle, to pick a random thing out of thin air ;) that might 
actually indicate whether this actually works or not?

Or is it just so experimental that no real program that uses aio can 
actually work yet?

		Linus
