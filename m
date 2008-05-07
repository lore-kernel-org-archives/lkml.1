Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbYEGOpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbYEGOpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbYEGOpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:45:33 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37760 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756602AbYEGOpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:45:31 -0400
Date: Wed, 7 May 2008 15:35:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507153538.446693af@core>
In-Reply-To: <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang>
	<20080506114449.GC32591@elte.hu>
	<1210126286.3453.37.camel@ymzhang>
	<1210131712.3453.43.camel@ymzhang>
	<87lk2mbcqp.fsf@basil.nowhere.org>
	<20080507114643.GR19219@parisc-linux.org>
	<87hcdab8zp.fsf@basil.nowhere.org>
	<alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But my preferred option would indeed be just turning it back into a 
> spinlock - and screw latency and BKL preemption - and having the RT people 
> who care deeply just work on removing the BKL in the long run.

It isn't as if the RT build can't use a different lock type to the
default build.

> Is BKL preemption worth it? Sounds very dubious. Sounds even more dubious 
> when we now apparently have even more reason to aim for removing the BKL 
> rather than trying to mess around with it.

We have some horrible long lasting BKL users left unfortunately.

Alan
