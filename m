Return-Path: <linux-kernel-owner+w=401wt.eu-S1030393AbXFHPyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030393AbXFHPyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932836AbXFHPyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:54:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40625 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752121AbXFHPyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:54:38 -0400
Date: Fri, 8 Jun 2007 16:59:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
Message-ID: <20070608165910.576c9949@the-village.bc.nu>
In-Reply-To: <20070608154908.GG25649@havoc.gtf.org>
References: <alpine.LFD.0.98.0706071352440.4205@woody.linux-foundation.org>
	<20070607224746.GA23290@havoc.gtf.org>
	<46690D10.9040808@gmail.com>
	<20070608122750.7f8ae0e0@the-village.bc.nu>
	<46693E33.6080705@gmail.com>
	<20070608124058.7948dee1@the-village.bc.nu>
	<20070608142822.GB25649@havoc.gtf.org>
	<20070608163615.3177dd9a@the-village.bc.nu>
	<20070608153256.GD25649@havoc.gtf.org>
	<20070608164630.0cec98ff@the-village.bc.nu>
	<20070608154908.GG25649@havoc.gtf.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree IT821x wants fixing, FWIW, just trying to get a handle on
> the big picture.  I'm not surprised that IT821x gets reset wrong,
> since it's a very non-standard BIOS.

Its a firmware emulation bug, the IT821X is emulating an IDE device
rather than neccessarily exposing one directly to the kernel.
