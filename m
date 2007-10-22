Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbXJVE2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbXJVE2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 00:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbXJVE2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 00:28:33 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:36714 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbXJVE2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 00:28:33 -0400
Date: Sun, 21 Oct 2007 21:28:32 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       =?ISO-8859-15?Q?Morten_B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Re: Interaction between Xen and XFS: stray RW mappings
In-Reply-To: <471C1A61.1010001@goop.org>
Message-ID: <alpine.DEB.0.9999.0710212128180.2320@twinlark.arctic.org>
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <4712A254.4090604@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007, Jeremy Fitzhardinge wrote:

> dean gaudet wrote:
> > On Mon, 15 Oct 2007, Nick Piggin wrote:
> >
> >   
> >> Yes, as Dave said, vmap (more specifically: vunmap) is very expensive
> >> because it generally has to invalidate TLBs on all CPUs.
> >>     
> >
> > why is that?  ignoring 32-bit archs we have heaps of address space 
> > available... couldn't the kernel just burn address space and delay global 
> > TLB invalidate by some relatively long time (say 1 second)?
> >   
> 
> Yes, that's precisely the problem.  xfs does delay the unmap, leaving
> stray mappings, which upsets Xen.

sounds like a bug in xen to me :)

-dean
