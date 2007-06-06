Return-Path: <linux-kernel-owner+w=401wt.eu-S934111AbXFFAES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111AbXFFAES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 20:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764804AbXFFAEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 20:04:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:47830 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764245AbXFFAEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 20:04:08 -0400
Subject: Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other
	woes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1181087462.2788.8.camel@entropy>
References: <1181006711.31677.97.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
	 <1181009413.31677.117.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com>
	 <1181013756.31677.123.camel@localhost.localdomain>
	 <1181023787.2785.14.camel@entropy>
	 <1181028453.31677.127.camel@localhost.localdomain>
	 <1181087462.2788.8.camel@entropy>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 10:03:58 +1000
Message-Id: <1181088238.31677.150.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 16:51 -0700, Nicholas Miell wrote:
> Yes, that's certainly wrong, but that's an implementation issue. I was
> more concerned about the design of the API.
> 
> Naively, I would expect a reads on a signalfd to return either process
> signals or thread signals targeted towards the thread doing the read.
> 
> What it actually does (delivering process signals or thread signals
> targeted towards the thread that created the signalfd) is weird.
> 
> For one, it means you can't create a single signalfd, stick it in an
> epoll set, and then wait on that set from multiple threads. 

Heh, well, I'll let you discuss that apsect with Davide. Right now, I'm
just trying to make sure that the implementation in the kernel copes :-)

Ben.


