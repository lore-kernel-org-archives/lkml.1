Return-Path: <linux-kernel-owner+w=401wt.eu-S933839AbXHVVSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933839AbXHVVSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763382AbXHVVSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:18:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35403 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763201AbXHVVSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:18:33 -0400
Date: Wed, 22 Aug 2007 22:25:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
Message-ID: <20070822222528.7c58f1e9@the-village.bc.nu>
In-Reply-To: <20070822220451.GJ8058@bingen.suse.de>
References: <46CBC842.4070100@vmware.com>
	<20070822102217.GE2642@bingen.suse.de>
	<46CC68D9.5060200@vmware.com>
	<20070822175918.GB8058@bingen.suse.de>
	<46CC6D63.2010204@vmware.com>
	<20070822194632.GD8058@bingen.suse.de>
	<46CC9FF2.3040406@vmware.com>
	<20070822220451.GJ8058@bingen.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I still think it's preferable to change some drivers than everybody.
> 
> AFAIK BusLogic as real hardware is pretty much dead anyways,
> so you're probably the only primary user of it anyways.
> Go wild on it!

I don't believe anyone is materially maintaining the buslogic driver and
in time its going to break completely.

> Well that might be. I just think it would be a mistake
> to design paravirt_ops based on someone's short term release engineering
> considerations.

Agreed, especially as an interface where each in or out traps into the
hypervisor is broken even for the model of virtualising hardware. 

> I thought we had that already?  But can't find it now :/

pci_iomap() and friends. 

Alan
