Return-Path: <linux-kernel-owner+w=401wt.eu-S1764366AbXEVAew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764366AbXEVAew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758150AbXEVAeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:34:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34985 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757001AbXEVAea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:34:30 -0400
Date: Tue, 22 May 2007 01:34:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Tejun Heo <htejun@gmail.com>, jeff@garzik.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, Alan Cox <alan@redhat.com>
Subject: Re: [patch 07/69] libata-sff: Undo bug introduced with pci_iomap
 changes
Message-ID: <20070522013424.3870ead3@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.98.0705211614210.3890@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>
	<20070521191701.791285000@sous-sol.org>
	<alpine.LFD.0.98.0705211614210.3890@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 16:18:25 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 21 May 2007, Chris Wright wrote:
> > ---
> > [chrisw: Why is this not upstream yet?]
> 
> And equally importantly, why is it even in the stable queue if it's not 
> upstream.

Its not relevant to upstream - upstream has different updates which
removed the bug but not in a clean "backport this" way.

> It's against stable rules, and it means that we may have stuff that gets 
> fixed in -stable and not in -upstream, if people don't notice. THAT IS 
> BAD

Then the rules are stupid in this specific case.

Alan
