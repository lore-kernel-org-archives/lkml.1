Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbXKMRcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbXKMRcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbXKMRcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:32:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55952 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754952AbXKMRce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:32:34 -0500
Date: Tue, 13 Nov 2007 17:30:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Benoit Boissinot <bboissin@gmail.com>, Mark Lord <liml@rtr.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113173019.14480202@the-village.bc.nu>
In-Reply-To: <20071113171356.GA25824@thunk.org>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
	<20071113.033946.114918709.davem@davemloft.net>
	<20071113034916.2556edd7.akpm@linux-foundation.org>
	<20071113.035824.40509981.davem@davemloft.net>
	<20071113041259.79c9a8c5.akpm@linux-foundation.org>
	<20071113134029.GA30978@elte.hu>
	<4739AFE0.20705@rtr.ca>
	<40f323d00711130752k19cab8eauc3456721274b3267@mail.gmail.com>
	<20071113171356.GA25824@thunk.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The other an automated set of standard pre-built bisection points so
> that testers can more easily localize a bug down to a few hundred
> commits without needing to learn how to use "git bisect" (think Ubuntu
> users).

Before that you want a flowchart or instruction list of boot options to
try. A lot of errors can be localised simply by asking the reported to
boot with things like "iommu=off", "pci=routeirq", "apci=off" etc

That takes a lot less time to run through and can be very informative.

Alan
