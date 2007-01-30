Return-Path: <linux-kernel-owner+w=401wt.eu-S1751246AbXA3UDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbXA3UDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 15:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbXA3UDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 15:03:35 -0500
Received: from ns2.suse.de ([195.135.220.15]:54915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbXA3UDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 15:03:31 -0500
Date: Tue, 30 Jan 2007 21:06:12 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Denis Vlasenko <vda.linux@googlemail.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Linus Torvalds <torvalds@osdl.org>, Viktor <vvp01@inbox.ru>,
       Aubrey <aubreylee@gmail.com>, Hua Zhong <hzhong@gmail.com>,
       Hugh Dickins <hugh@veritas.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: O_DIRECT question
Message-ID: <20070130200612.GS8030@opteron.random>
References: <200701270035.31285.vda.linux@googlemail.com> <45BCBECE.4080405@tmr.com> <200701281803.08201.vda.linux@googlemail.com> <20070129170056.GJ8030@opteron.random> <45BE7D99.70200@cfl.rr.com> <20070130023056.GN8030@opteron.random> <45BF65E3.6070102@cfl.rr.com> <20070130164806.GQ8030@opteron.random> <45BF9381.8010108@cfl.rr.com> <20070130195720.GR8030@opteron.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130195720.GR8030@opteron.random>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 08:57:20PM +0100, Andrea Arcangeli wrote:
> Please try yourself, it's simple enough:
> 
>        time dd if=/dev/hda of=/dev/null bs=16M count=100
>        time dd if=/dev/hda of=/dev/null bs=16M count=100 iflag=sync

sorry, reading won't help much to exercise sync ;). But the direct
line is enough to show the effect of I/O pipeline stall. To
effectively test sync of course you want to write to a file instead
(unless you want to wipe out /dev/hda ;)
