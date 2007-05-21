Return-Path: <linux-kernel-owner+w=401wt.eu-S1765816AbXEUXa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765816AbXEUXa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757888AbXEUXaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:30:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51899 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757712AbXEUXaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:30:09 -0400
Date: Mon, 21 May 2007 16:18:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Wright <chrisw@sous-sol.org>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Tejun Heo <htejun@gmail.com>, jeff@garzik.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@redhat.com>
Subject: Re: [patch 07/69] libata-sff: Undo bug introduced with pci_iomap
 changes
In-Reply-To: <20070521191701.791285000@sous-sol.org>
Message-ID: <alpine.LFD.0.98.0705211614210.3890@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>
 <20070521191701.791285000@sous-sol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 May 2007, Chris Wright wrote:
> ---
> [chrisw: Why is this not upstream yet?]

And equally importantly, why is it even in the stable queue if it's not 
upstream.

It's against stable rules, and it means that we may have stuff that gets 
fixed in -stable and not in -upstream, if people don't notice. THAT IS 
BAD!

Having fixes in stable that don't exist in upstream make -stable be 
worse than pointless - it means that we actively _lose_ bug-reports. It 
may sound like a good idea in the short run, but it's a *horrible* thing 
for the long run.

IOW, this should not be on the table for -stable, and people involved 
should have made sure it's in -upstream first!

And no, I do not think it's languishing in my mailqueue. I'm pretty sure 
it's languishing somewhere else. 

		Linus
