Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbXKWBd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbXKWBd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 20:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbXKWBdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 20:33:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41838 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388AbXKWBds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 20:33:48 -0500
Date: Fri, 23 Nov 2007 01:29:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de,
       johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
Message-ID: <20071123012911.3266dba6@the-village.bc.nu>
In-Reply-To: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Most architectures are unable to perform unaligned memory accesses. Any
> unaligned access causes a processor exception.

Not all. Some simply produce the wrong answer - thats oh so much more
exciting.

> You may be wondering why you have never seen these problems on your own
> architecture. Some architectures (such as i386 and x86_64) do not have this
> limitation, but nevertheless it is important for you to write portable code
> that works everywhere.

Its usually faster if you don't misalign on x86 as well.

Alan
