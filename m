Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYE3JvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYE3JvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYE3JvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:51:00 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:47365 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbYE3Ju7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:50:59 -0400
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
	kernel.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>,
       David Woodhouse <dwmw2@infradead.org>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       David Miller <davem@davemloft.net>
In-Reply-To: <20080530103107.4f71cfe3@core>
References: <1211995212.3445.52.camel@localhost.localdomain>
	 <20080528.225826.40264516.davem@davemloft.net>
	 <1212041839.8888.38.camel@pasglop> <20080529124548.GC8065@mit.edu>
	 <1212077700.26088.83.camel@shinybook.infradead.org>
	 <483F002E.5060002@garzik.org>
	 <1212095864.24826.2.camel@lappy.programming.kicks-ass.net>
	 <483F3EC4.5050700@zytor.com>  <20080530103107.4f71cfe3@core>
Content-Type: text/plain
Date: Fri, 30 May 2008 11:50:59 +0200
Message-Id: <1212141059.12349.240.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-30 at 10:31 +0100, Alan Cox wrote:
> On Thu, 29 May 2008 16:39:48 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > Peter Zijlstra wrote:
> > > 
> > > I certainly agree, pushing more and more into initrd just annoys the
> > > hell out of me.
> > > 
> > > I'd argue to include everything needed to build (and esp cross build) an
> > > initrd into the kernel - up until that point initrds are useless.
> > > 
> > 
> > I tried to push for that two years ago.  I'd be more than happy to pull 
> > that out of the freezer.
> 
> Its kind of irrelevant if you need an initrd or not. The only question of
> relevance is "does it get built when I type make all". Almost all Linux
> users are using initrd without problem - because their distro ensures
> "make install" and the packaged kernels do the right thing.

Its my own convenience I'm serving here. I hardly ever do a local
install. And for the old machines a local build just isn't even an
option.

It's what benh said; I just want a single netbootable image. And cross
buildling initrds is just impossible - which makes the whole solution
useless.

