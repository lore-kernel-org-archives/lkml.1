Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbXKGP23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbXKGP23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXKGP2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:28:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48302 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753815AbXKGP2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:28:20 -0500
Date: Wed, 7 Nov 2007 15:28:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Mark Lord <lkml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH 1/2] libata: Support PIO polling-only hosts.
Message-ID: <20071107152829.244afe30@the-village.bc.nu>
In-Reply-To: <20071107145326.GA27752@linux-sh.org>
References: <20071107081052.GA25913@linux-sh.org>
	<20071107130940.16b5ea86@the-village.bc.nu>
	<20071107132702.GA27488@linux-sh.org>
	<4731C71A.4000406@rtr.ca>
	<20071107145326.GA27752@linux-sh.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So I'll change the check to IRQ#0 == invalid, but if that's to be
> enforced kernel-wide, then all of the existing NO_IRQ cases should be
> ripped out and set to 0. This way at least people are getting screwed
> consistently, rather than just in particular subsystems.

Thats been gradually happening. Its now pretty clean except for powerpc
and odd bits of ARM stuff

Alan
