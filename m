Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbZCWOLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbZCWOLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZCWOLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:11:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:49529 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZCWOLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:11:12 -0400
Date: Mon, 23 Mar 2009 07:12:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: =?UTF-8?B?5bCP5aSp?= <xtfeng@gmail.com>, Markus <M4rkusXXL@web.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12872] pwc mmap always fails with EAGAIN
Message-ID: <20090323071218.286c10e0@infradead.org>
In-Reply-To: <20090323104945.0fc497e6@lxorguk.ukuu.org.uk>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
	<20090322142837.2df0d93d@lxorguk.ukuu.org.uk>
	<20090322144516.GA13129@elte.hu>
	<200903222058.12924.M4rkusXXL@web.de>
	<7b6bb4a50903230341r6ab4a910l401a49d41aa289c7@mail.gmail.com>
	<20090323104945.0fc497e6@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009 10:49:45 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > >    Rename the pagerange_is_ram() to pat_pagerange_is_ram() and
> > > add the "track legacy 1MB region as non RAM" condition.
> 
> But the lowest 640K are most definitely RAM.

not all of it ;)

"ram" is defined as "the kernel memory allocator knows about it and
would hand it out" in this context; BIOS owned areas are not "ram" in
this context.
-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
