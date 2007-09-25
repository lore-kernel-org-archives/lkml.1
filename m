Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbXIYWI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbXIYWI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbXIYWIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:08:50 -0400
Received: from www.tglx.de ([213.239.205.147]:34010 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbXIYWIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:08:49 -0400
Subject: Re: [PATCH] UML - time build fix
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
In-Reply-To: <20070925215629.GA10926@c2.user-mode-linux.org>
References: <20070925173713.GA8262@c2.user-mode-linux.org>
	 <1190750055.17409.38.camel@chaos>
	 <20070925215629.GA10926@c2.user-mode-linux.org>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 00:08:47 +0200
Message-Id: <1190758127.17409.81.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

On Tue, 2007-09-25 at 17:56 -0400, Jeff Dike wrote:
> On Tue, Sep 25, 2007 at 09:54:15PM +0200, Thomas Gleixner wrote:
> > On Tue, 2007-09-25 at 13:37 -0400, Jeff Dike wrote:
> > > Put back an implementation of timeval_to_ns in
> > > arch/um/os-Linux/time.c.  tglx pointed out in his review of tickless
> > > support that there was a perfectly good implementation of it in
> > > linux/time.h.  The problem is that this is userspace code which can't
> > > pull in kernel headers and there doesn't seem to be a libc version.
> > 
> > Oops. Did not notice. 
> 
> It's a UML peculiarity...
> 
> > Can't we move it into some header file which is accessible from everywhere ?
> 
> Not in the generic kernel.  UML has some generally includable headers
> of its own, but that doesn't really help.
> 
> The one thing that would help is a libc timeval_to_ns.

Fair enough.

	tglx


