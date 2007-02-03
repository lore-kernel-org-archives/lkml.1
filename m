Return-Path: <linux-kernel-owner+w=401wt.eu-S1946171AbXBBXwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946171AbXBBXwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 18:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946172AbXBBXwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 18:52:24 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49397 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946171AbXBBXwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 18:52:24 -0500
Date: Sat, 3 Feb 2007 00:04:15 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070203000415.053af657@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0702021512450.15057@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	<df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net>
	<20070201083611.GC18233@elte.hu>
	<Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
	<20070202104900.GA13941@elte.hu>
	<Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
	<20070202195932.15b9b4ed@localhost.localdomain>
	<Pine.LNX.4.64.0702021155460.15057@woody.linux-foundation.org>
	<20070202213019.202e8db5@localhost.localdomain>
	<Pine.LNX.4.64.0702021322310.15057@woody.linux-foundation.org>
	<20070202224259.GB1212@elte.hu>
	<Pine.LNX.4.64.0702021459550.15057@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702021512450.15057@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> When parallelising "real work", I absolutely agree with you: we should use 
> threads. But you need to look at what it is we parallelize here, and ask 
> yourself why we're doing what we're doing, and why people aren't *already* 
> just using a separate thread for it.

Because its a pain in the arse and because its very hard to self tune. If
you've got async_anything then the thread/fibril/synchronous/whatever
decision can be made kernel side based upon expected cost and other
tradeoffs, even if its as dumb as per syscall or per syscall/filp type
guessing.

Alan
