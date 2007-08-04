Return-Path: <linux-kernel-owner+w=401wt.eu-S1765886AbXHDU2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765886AbXHDU2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 16:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760224AbXHDU2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 16:28:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36178 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759925AbXHDU2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 16:28:34 -0400
Message-ID: <46B4E161.9080100@garzik.org>
Date: Sat, 04 Aug 2007 16:28:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070803123712.987126000@chello.nl>	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>	<20070804063217.GA25069@elte.hu>	<20070804070737.GA940@elte.hu>	<20070804103347.GA1956@elte.hu>	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>	<20070804163733.GA31001@elte.hu>	<alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>	<46B4C0A8.1000902@garzik.org>	<20070804191205.GA24723@lazybastard.org>	<20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu>
In-Reply-To: <20070804211156.5f600d80@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> In some setups it will and in others it won't. Nor is it the only
> application that has this requirement. Ext3 currently is a standards
> compliant file system. Turn off atime and its very non standards
> compliant, turn to relatime and its not standards compliant but nobody
> will break (which is good)

Linux has always been a "POSIX unless its stupid" type of system.  For 
the upstream kernel, we should do the right thing -- noatime by default 
-- but allow distros and people that care about rigid compliance to 
easily change the default.


(from another message)
> If you want to sort this in Fedora for example you just need to package
> and announce a desktop-tuning rpm which makes the relevant updates on
> install and reverses them on remove. Stick the scheduler/vm tuning values
> in as well and the disk queue tweaks.
> 
> Regardless of the kernel defaults people will install such a package
> en-mass...

<chuckle>  Sounds like an effective idea :)

Though strictly in the context of atime vs. noatime, servers benefit 
from that too, not just desktop.

	Jeff


