Return-Path: <linux-kernel-owner+w=401wt.eu-S1030820AbXDQRvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030820AbXDQRvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030812AbXDQRvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:51:06 -0400
Received: from thunk.org ([69.25.196.29]:60422 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030820AbXDQRvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:51:04 -0400
Date: Tue, 17 Apr 2007 13:50:55 -0400
From: Theodore Tso <tytso@mit.edu>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070417175055.GA24963@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Daniel Hazelton <dhazelton@enter.net>,
	Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>,
	"David R. Litwin" <presently42@gmail.com>,
	linux-kernel@vger.kernel.org
References: <op.tqw1g6n0ftfxs2@localhost.localdomain> <20070417131045.GB18373@thunk.org> <Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl> <200704171222.19892.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704171222.19892.dhazelton@enter.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 12:22:19PM -0400, Daniel Hazelton wrote:
> Nope. You've just ignored it when it was explained *why* the existing ZFS code 
> cannot be simply be ported to Linux. If you really need ZFS on linux, might I 
> suggest that you port the code on your own and maintain whatever patches are 
> needed to use it? As it stands ZFS *might* show up in Linux as a from-scratch 
> implementation, although I stress the "might" because there are patents 
> involved.

Given that Sun has reportedly filed a huge number of patents covering
ZFS and has refused to make them available for anything other than
Solaris --- and there are senior Sun programmers who have on record
stated that one of the reasons why Sun picked the CDDL was precisely
because it was incompatible with GPL and Sun fears Linux ---- I
wouldn't bet on Sun being willing to making a patent license available
to a hypothetical alternate implementation of the ZFS format for
Linux.

Again, this is is Sun's fault, and it's because they fear Linux, and
it may have something to do with the fact that the vast majority of
their Opteron boxes get Linux installed instead of Solaris.  The
bottom line is that people who would like ZFS need to understand that
the code is Copyright by Sun, and there are almost certainly patents
owned by Sun, and if they choose licenses that are explicitly designed
to be incompatible with Linux, we should respect Sun's deep-seated
fear of Linux, and we can continue trying to innovate around better
filesystem and LVM storage technologies, as opposed to trying to chase
the ZFS tail lights.

Of course, this is all open source.  If someone wants to work on
reimplementing ZFS from scratch, either in userspace or in the kernel,
certainly the Linux community won't stop them.  Given the patent
issues Linus might not feel comfortable including it in the mainline
sources without a promise from Sun that they won't sue the pants off
of him and The Linux Foundation, but again, that's Sun's decision, and
no one else can help you there.

						- Ted
