Return-Path: <linux-kernel-owner+w=401wt.eu-S1761618AbXFFKSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618AbXFFKSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758608AbXFFKSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:18:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60806 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751610AbXFFKS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:18:29 -0400
Date: Wed, 6 Jun 2007 11:23:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 3/6] lguest suppress IDE probing
Message-ID: <20070606112308.49a652f6@the-village.bc.nu>
In-Reply-To: <1181092258.14054.87.camel@localhost.localdomain>
References: <1181055308.14054.36.camel@localhost.localdomain>
	<1181055396.14054.38.camel@localhost.localdomain>
	<1181055483.14054.40.camel@localhost.localdomain>
	<20070605170747.256f6631@the-village.bc.nu>
	<1181092258.14054.87.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, Jeremy suggested claiming the entire IO space.  That works for
> Xen domU too, and makes some amount of sense.

Agreed

> > Better yet just don't compile in the old IDE stuff, lguest doesn't have a
> > PCI or ISA bus anyway.
> 
> Sure, but the "run the same kernel as guest and host" is a really nice
> feature.

Modules dear boy, modules ;)

> > Alternatively make the IDE I/O space return 0xFF and it'll skip them
> > anyway.
> 
> Hmm, every "in" should be returning 0xFFs, but I still get the delay and
> the probing.  Xen domU gets it too.

Can you see in a debugger where it is spending the time. 0xFF should be
taken as "no port, move on nothing to see"
