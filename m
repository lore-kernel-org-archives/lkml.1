Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYE3Jpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYE3Jpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYE3Jpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:45:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33819 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751725AbYE3Jpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:45:35 -0400
Date: Fri, 30 May 2008 10:31:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jeff Garzik <jeff@garzik.org>,
       David Woodhouse <dwmw2@infradead.org>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       David Miller <davem@davemloft.net>
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
 kernel.
Message-ID: <20080530103107.4f71cfe3@core>
In-Reply-To: <483F3EC4.5050700@zytor.com>
References: <1211995212.3445.52.camel@localhost.localdomain>
	<20080528.225826.40264516.davem@davemloft.net>
	<1212041839.8888.38.camel@pasglop>
	<20080529124548.GC8065@mit.edu>
	<1212077700.26088.83.camel@shinybook.infradead.org>
	<483F002E.5060002@garzik.org>
	<1212095864.24826.2.camel@lappy.programming.kicks-ass.net>
	<483F3EC4.5050700@zytor.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 16:39:48 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Peter Zijlstra wrote:
> > 
> > I certainly agree, pushing more and more into initrd just annoys the
> > hell out of me.
> > 
> > I'd argue to include everything needed to build (and esp cross build) an
> > initrd into the kernel - up until that point initrds are useless.
> > 
> 
> I tried to push for that two years ago.  I'd be more than happy to pull 
> that out of the freezer.

Its kind of irrelevant if you need an initrd or not. The only question of
relevance is "does it get built when I type make all". Almost all Linux
users are using initrd without problem - because their distro ensures
"make install" and the packaged kernels do the right thing.

Alan
