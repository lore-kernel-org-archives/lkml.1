Return-Path: <linux-kernel-owner+w=401wt.eu-S1764176AbXHNWf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764176AbXHNWf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXHNWfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:35:01 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40787 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753416AbXHNWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:34:59 -0400
Date: Tue, 14 Aug 2007 23:42:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Hajime Inoue <hinoue@ccsl.carleton.ca>, linux-kernel@vger.kernel.org
Subject: Re: System call interposition/unprotecting the table
Message-ID: <20070814234206.76121d02@the-village.bc.nu>
In-Reply-To: <p73zm0tnbf8.fsf@bingen.suse.de>
References: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca>
	<20070814000956.7c8929dd@the-village.bc.nu>
	<46C1E5F5.9050702@ccsl.carleton.ca>
	<p73zm0tnbf8.fsf@bingen.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So even with Alan's hypervisor support the whole thing would be still
> quite holey.  The argument of raising the bar also doesn't seem very

Its materially harder, especially with the hypervisor.

> convincing to me, because attackers reuse code too and it's enough
> when someone publishes such code once, then they can cut'n'paste
> it into any exploits forever.

Then you fix the specific case and the game continues.

> In general the .data protection is only considered a debugging
> feature. I don't know why Fedora enables it in their production
> kernels.

That would be because we think you are wrong 8)

Alan
