Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbXFOMtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbXFOMtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbXFOMt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:49:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58691 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756206AbXFOMt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:49:27 -0400
Date: Fri, 15 Jun 2007 13:54:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Message-ID: <20070615135420.7fe2e4c1@the-village.bc.nu>
In-Reply-To: <200706151443.13511.ak@suse.de>
References: <200706151355.57464.ak@suse.de>
	<200706151131.38429.arnd@arndb.de>
	<5717.1181909357@redhat.com>
	<200706151443.13511.ak@suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Why does it break them? It should just make them a little slower.
> > Not all CPUs deliver recoverable misalignment exceptions.   
> These CPUs are too broken to run Linux then.

People fixed that up
> 
> > > The network code requires unaligned accesses to work anyways so if your
> > > architecture doesn't support them it is already remotely crashable.
> >
> > I thought we'd fixed all that.
> 
> Did you audit the complete network stack?

For the parts used by the processors in question yes people have done
that work so using the types without unaligned.

Alan
