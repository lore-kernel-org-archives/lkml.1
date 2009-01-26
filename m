Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZAZVmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZAZVmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZAZVmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:42:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43540 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbZAZVmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:42:40 -0500
Date: Mon, 26 Jan 2009 22:42:23 +0100
From: Pavel Machek <pavel@suse.cz>
To: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg Kroah-Hartman <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in
	wb35_probe()
Message-ID: <20090126214223.GD30819@elf.ucw.cz>
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI> <20090122114237.GA13845@atrey.karlin.mff.cuni.cz> <4978C812.90702@gmail.com> <20090122211052.GA1928@elf.ucw.cz> <4978F47C.6010909@gmail.com> <4978F3CF.2010301@cs.helsinki.fi> <497E0F94.8000003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497E0F94.8000003@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ok, test done with git current version of w35und over 2.6.28-gentoo-r1
> > (2.6.28.1
> > and some patches)
> 
> Adding Pekka's patch

> # ping 10.0.4.1
> PING 10.0.4.1 (10.0.4.1) 56(84) bytes of data.
> 64 bytes from 10.0.4.1: icmp_seq=1 ttl=64 time=0.064 ms
> 64 bytes from 10.0.4.1: icmp_seq=2 ttl=64 time=0.060 ms
......

> Ok, with kernel 2.6.8.1, and your patch it seems to work with channel 1, no
> encryption, opensystem authentication.


Congratulation, you have made it :-). Now, question is why it does not
work on 2.6.29-rc1. And with your testing we know something in core
kernel changed and broke it.

Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
