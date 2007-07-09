Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbXGIKCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbXGIKCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXGIKBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:01:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56174 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751315AbXGIKBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:01:51 -0400
Date: Mon, 9 Jul 2007 11:06:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: Adrian Bunk <bunk@stusta.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
Message-ID: <20070709110605.4efaea8b@the-village.bc.nu>
In-Reply-To: <200707091139.25240.ak@suse.de>
References: <20070617214231.GA3588@stusta.de>
	<200707090102.21784.ak@suse.de>
	<20070708231726.GW3492@stusta.de>
	<200707091139.25240.ak@suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007 11:39:25 +0200
Andi Kleen <ak@suse.de> wrote:

> 
> > > It will be solved differently longer term, but short term the fix
> > > was still needed. There are limits on what can be done late 
> > > in the release cycle so simple patches win.
> > 
> > Your patch got into Linus' tree in the middle of the merge window...
> 
> Even in the middle of the merge window it might be too late
> to do some large scale restructuring (as would have been needed
> for this particular issue) 

You should have reverted the change and held it over for 2.6.23-rc1 then
as other developers do with problem code.

Alan

