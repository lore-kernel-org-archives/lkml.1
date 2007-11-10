Return-Path: <linux-kernel-owner+w=401wt.eu-S1763607AbXKJDhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763607AbXKJDhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 22:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXKJDhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 22:37:08 -0500
Received: from xenotime.net ([66.160.160.81]:38244 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751986AbXKJDhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 22:37:07 -0500
Date: Fri, 9 Nov 2007 19:37:02 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
Message-Id: <20071109193702.e7bfa5fb.rdunlap@xenotime.net>
In-Reply-To: <4735242B.1010801@garzik.org>
References: <20071109230812.GA5176@uranus.ravnborg.org>
	<4735242B.1010801@garzik.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Nov 2007 22:23:23 -0500 Jeff Garzik wrote:

> Sam Ravnborg wrote:
> > This is the patch that get rid of ARCH=i386 and ARCH=x86_64
> > and introduce ARCH=x86.
> > It touches several files but the changes are all one or two-liners.
> > 
> >       x86: drop backward compatibility symlinks to i386/boot and x86_64/boot
> >       kbuild: sanity check the specified arch
> 
> 
> IMO it negatives impacts the workflow when you -remove- the ability to 
> set 32/64-bit on the make command line.
> 
> Building and testing for both architectures now requires the additional 
> step of editing .config, which is a clear workflow negative impact at 
> least for me.
> 
> I switch between other cross-compiled arches (alpha, usually) on the 
> makefile command line
> 
> Yes, I know other 32/64-bit arches require .config editing.  That 
> doesn't change the basic fact that this is a workflow regression.

Thanks.  Well said.  I strongly agree.

---
~Randy
