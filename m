Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbXHEMvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbXHEMvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 08:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbXHEMvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 08:51:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48380 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750927AbXHEMvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 08:51:03 -0400
Date: Sun, 5 Aug 2007 13:47:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: J??rn Engel <joern@logfs.org>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805134750.691e2e74@the-village.bc.nu>
In-Reply-To: <20070805072141.GA4414@elte.hu>
References: <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804163733.GA31001@elte.hu>
	<alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>
	<46B4C0A8.1000902@garzik.org>
	<20070804191205.GA24723@lazybastard.org>
	<20070804192130.GA25346@elte.hu>
	<20070804211156.5f600d80@the-village.bc.nu>
	<20070804202830.GA4538@elte.hu>
	<20070804210351.GA9784@elte.hu>
	<20070804225121.5c7b66e0@the-village.bc.nu>
	<20070805072141.GA4414@elte.hu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > we can move from atime to noatime by default on FC8 with appropriate 
> > release note warnings and having a couple of betas to find out what 
> > other than mutt goes boom.
> 
> btw., Mutt does not go boom, i use it myself. It works just fine and 
> notices new mails even on a noatime,nodiratime filesystem.

Configuration dependant, and also mutt and the shell will misreport new
mail with noatime on the mail spool. The shell should probably use
inotify of course but that change has to be made.
