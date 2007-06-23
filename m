Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbXFWJDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbXFWJDa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 05:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbXFWJDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 05:03:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39061 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752748AbXFWJDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 05:03:21 -0400
Date: Sat, 23 Jun 2007 10:08:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Yinghai Lu <Yinghai.Lu@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Message-ID: <20070623100824.3d96186e@the-village.bc.nu>
In-Reply-To: <200706230214.02535.ak@suse.de>
References: <200706221219.16243.yinghai.lu@sun.com>
	<m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
	<20070622231951.4d516215@the-village.bc.nu>
	<200706230214.02535.ak@suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But I doubt this was YH's problem - the panic kernel memory
> is always reserved and there shouldn't be any ongoing DMAs in this
> area anyways. And what happens outside the kdump kernel shouldn't matter.

In the kdump case it looks like there is still DMA going on through the
GART on some systems when kdump zaps it.
