Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbXIYV53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbXIYV53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 17:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbXIYV5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 17:57:22 -0400
Received: from [198.99.130.12] ([198.99.130.12]:55134 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbXIYV5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 17:57:22 -0400
Date: Tue, 25 Sep 2007 17:56:29 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] UML - time build fix
Message-ID: <20070925215629.GA10926@c2.user-mode-linux.org>
References: <20070925173713.GA8262@c2.user-mode-linux.org> <1190750055.17409.38.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190750055.17409.38.camel@chaos>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 09:54:15PM +0200, Thomas Gleixner wrote:
> On Tue, 2007-09-25 at 13:37 -0400, Jeff Dike wrote:
> > Put back an implementation of timeval_to_ns in
> > arch/um/os-Linux/time.c.  tglx pointed out in his review of tickless
> > support that there was a perfectly good implementation of it in
> > linux/time.h.  The problem is that this is userspace code which can't
> > pull in kernel headers and there doesn't seem to be a libc version.
> 
> Oops. Did not notice. 

It's a UML peculiarity...

> Can't we move it into some header file which is accessible from everywhere ?

Not in the generic kernel.  UML has some generally includable headers
of its own, but that doesn't really help.

The one thing that would help is a libc timeval_to_ns.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
