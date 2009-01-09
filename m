Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbZAIV3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbZAIV3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbZAIV3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:29:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:41288 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612AbZAIV27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:28:59 -0500
Date: Fri, 9 Jan 2009 13:30:56 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Partially defer some of the async stuff to the next release
Message-ID: <20090109133056.01d278c4@infradead.org>
In-Reply-To: <20090109212201.780c52d0@lxorguk.ukuu.org.uk>
References: <20090109070910.233e5f3c@infradead.org>
	<alpine.LFD.2.00.0901091241470.6528@localhost.localdomain>
	<20090109212201.780c52d0@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 21:22:01 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Can we rather make this something that people can enable with a
> > "fastboot" option and is disabled by default? At least that way the
> > ATA people can see the problem, and don't just forget about it,
> > since we want it fixed.
> 
> Makes some sense - although the inode one should just take a hike at
> this point. Can the fastboot option live under staging perhaps - its
> analogous to staging drivers although clearly the code doesn't go
> there in this case ?
> 
> The trouble otherwise is "fast boot" sounds like something good for
> people to turn on, but right now it's the reverse.

I just coded it as a kernel command line option only

that's very much a "I know what I'm doing" kind of thng.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
