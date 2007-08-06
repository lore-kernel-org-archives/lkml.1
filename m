Return-Path: <linux-kernel-owner+w=401wt.eu-S1764915AbXHFTcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764915AbXHFTcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761512AbXHFTbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:31:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35899 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761018AbXHFTb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:31:26 -0400
Date: Mon, 6 Aug 2007 20:37:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, J??rn Engel <joern@logfs.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070806203710.39bdc42e@the-village.bc.nu>
In-Reply-To: <46B7626C.6050403@redhat.com>
References: <20070804070737.GA940@elte.hu>
	<20070804103347.GA1956@elte.hu>
	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804163733.GA31001@elte.hu>
	<alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>
	<46B4C0A8.1000902@garzik.org>
	<20070804191205.GA24723@lazybastard.org>
	<20070804192130.GA25346@elte.hu>
	<20070804192615.GA25600@lazybastard.org>
	<20070804194259.GA25753@lazybastard.org>
	<20070805203602.GB25107@infradead.org>
	<46B7626C.6050403@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We already tried that here. The response: "If noatime is so great, why
> isn't it the default in the kernel?"

Ok so we have a pile of people @redhat.com sitting on linux-kernel
complaining about Red Hat distributions not taking it up. Guys - can
we just fix it internally please like sensible folk ?

Ingo's latest 'not quite noatime' seems to cure mutt/tmpwatch so it might
finally make sense to do so.

Alan
