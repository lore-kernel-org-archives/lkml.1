Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbXGBQxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbXGBQxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 12:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbXGBQxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 12:53:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44209 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752238AbXGBQxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 12:53:46 -0400
Date: Mon, 2 Jul 2007 17:59:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: blink driver power saving
Message-ID: <20070702175926.30b2f718@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.98.0707020843100.9434@woody.linux-foundation.org>
References: <20070701125035.3f54d8b0@oldman>
	<200707012329.52918.ak@suse.de>
	<alpine.LFD.0.98.0707011511120.3323@woody.linux-foundation.org>
	<200707020159.51200.ak@suse.de>
	<alpine.LFD.0.98.0707020843100.9434@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Anyways, Stephen's patch just doesn't make sense: 
> > he clearly didn't understand the code at all. Before you
> > apply it and cripple it better drop the driver completely.
> 
> I think I will have to.

Make it depend on the kernel debug options and if you are really paranoid
also add a module option to enable it at boot time. The module option
works pretty well and various old and new IDE drivers do it to stop make
allyesconfig accidents
