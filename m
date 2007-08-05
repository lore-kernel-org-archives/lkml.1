Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbXHEMp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbXHEMp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 08:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbXHEMpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 08:45:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57496 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754306AbXHEMpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 08:45:11 -0400
Date: Sun, 5 Aug 2007 13:46:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Claudio Martins <ctpm@ist.utl.pt>, Jeff Garzik <jeff@garzik.org>,
       =?UTF-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805134640.2c7d1140@the-village.bc.nu>
In-Reply-To: <20070805072805.GB4414@elte.hu>
References: <20070803123712.987126000@chello.nl>
	<46B4E161.9080100@garzik.org>
	<20070804224706.617500a0@the-village.bc.nu>
	<200708050051.40758.ctpm@ist.utl.pt>
	<20070805014926.400d0608@the-village.bc.nu>
	<20070805072805.GB4414@elte.hu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The only remotely valid compatibility argument would be Mutt - but even 
> that handles it just fine. (we broke way more software via noexec)

And went through a sensible process of resolving it.

And its not just mutt. HSM stuff stops working which is a big deal as
stuff clogs up. The /tmp/ cleaning tools go wrong as well.

These are big deals because you seem intent on using a large hammer to
force a change that should be done properly by other means.

The /tmp cleaning for example can probably be done other ways in future
but the changes should be in place first.

