Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbXEQJpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbXEQJpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbXEQJpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:45:43 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:3167 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXEQJpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:45:42 -0400
Date: Thu, 17 May 2007 10:45:36 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Gerd Hoffmann <kraxel@suse.de>,
       Andi Kleen <ak@suse.de>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] early printk and boot console fixups.
In-Reply-To: <200705161214.16426.bjorn.helgaas@hp.com>
Message-ID: <Pine.LNX.4.64N.0705171038050.11098@blysk.ds.pg.gda.pl>
References: <45D5C473.4010608@suse.de> <200705160959.12433.bjorn.helgaas@hp.com>
 <Pine.LNX.4.64N.0705161803110.29569@blysk.ds.pg.gda.pl>
 <200705161214.16426.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Bjorn Helgaas wrote:

> >  Given the generic name of "uart" I am assuming this will work with any 
> > UART driver making use of the serial_core.c core -- am I correct?
> 
> I knew somebody would ask that eventually :-)
> 
> Unfortunately, the answer is "no."  "console=uart" only works with
> 8250-compatible devices.

 But is it a design limitation or is it just that other UART drivers have 
to be modified to work with this option?  My point is if the former, then 
the option should be something like "console=8250" (the right-hand side 
being the name of the driver involved; others may want to add support for 
other drivers).  If the latter, then it's fine as is as other UART drivers 
may be wired to this code as a need arises.

  Maciej
