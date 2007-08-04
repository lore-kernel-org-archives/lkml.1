Return-Path: <linux-kernel-owner+w=401wt.eu-S1765865AbXHDVoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765865AbXHDVoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 17:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761515AbXHDVoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 17:44:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49452 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761291AbXHDVog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 17:44:36 -0400
Date: Sat, 4 Aug 2007 22:51:21 +0100
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
Message-ID: <20070804225121.5c7b66e0@the-village.bc.nu>
In-Reply-To: <20070804210351.GA9784@elte.hu>
References: <20070804070737.GA940@elte.hu>
	<20070804103347.GA1956@elte.hu>
	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804163733.GA31001@elte.hu>
	<alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>
	<46B4C0A8.1000902@garzik.org>
	<20070804191205.GA24723@lazybastard.org>
	<20070804192130.GA25346@elte.hu>
	<20070804211156.5f600d80@the-village.bc.nu>
	<20070804202830.GA4538@elte.hu>
	<20070804210351.GA9784@elte.hu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> i cannot over-emphasise how much of a deal it is in practice. Atime 
> updates are by far the biggest IO performance deficiency that Linux has 
> today. Getting rid of atime updates would give us more everyday Linux 
> performance than all the pagecache speedups of the past 10 years, 
> _combined_.
> 
> it's also perhaps the most stupid Unix design idea of all times. Unix is 
> really nice and well done, but think about this a bit:

Think about the user for a moment instead. 

Do things right. The job of the kernel is not to "correct" for
distribution policy decisions. The distributions need to change policy.
You do that by showing the distributions the numbers. 

With a Red Hat on if we can move from /dev/hda to /dev/sda in FC7 then we
can move from atime to noatime by default on FC8 with appropriate release
note warnings and having a couple of betas to find out what other than
mutt goes boom.
