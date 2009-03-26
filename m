Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZCZDOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZCZDOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 23:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZCZDNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 23:13:51 -0400
Received: from THUNK.ORG ([69.25.196.29]:43501 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbZCZDNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 23:13:50 -0400
Date: Wed, 25 Mar 2009 23:13:37 -0400
From: Theodore Tso <tytso@mit.edu>
To: Neil Brown <neilb@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090326031337.GU32307@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <49C88C80.5010803@krogh.cc> <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com> <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <18890.60770.371109.185593@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18890.60770.371109.185593@notabene.brown>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 01:50:10PM +1100, Neil Brown wrote:
> I shouldn't be too hard to add some concept of total time to this.
> If we track the number of write-outs per unit time and use that together
> with a "target time for fsync" to scale the 'dirty_bytes' number, we
> might be able to auto-tune the amount of dirty space to fit the speeds
> of the drives.
> 
> We would probably start with each device having a very low "max dirty"
> number which would cause writeouts to start soon.  Once the device
> demonstrates that it can do n-per-second (or whatever) the VM would
> allow the "max dirty" number to drift upwards.  I'm not sure how best
> to get it to move downwards if the device slows down (or the kernel
> over-estimated).  Maybe it should regularly decay so that the device
> keeps have to "prove" itself.

This seems like a really cool idea.

						-Ted
