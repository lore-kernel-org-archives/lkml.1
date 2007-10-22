Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbXJVDSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbXJVDSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 23:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbXJVDSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 23:18:43 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:38080 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbXJVDSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 23:18:42 -0400
Date: Sun, 21 Oct 2007 20:18:41 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       =?ISO-8859-15?Q?Morten_B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Re: Interaction between Xen and XFS: stray RW mappings
In-Reply-To: <200710151415.07248.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org>
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <4712A254.4090604@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Nick Piggin wrote:

> Yes, as Dave said, vmap (more specifically: vunmap) is very expensive
> because it generally has to invalidate TLBs on all CPUs.

why is that?  ignoring 32-bit archs we have heaps of address space 
available... couldn't the kernel just burn address space and delay global 
TLB invalidate by some relatively long time (say 1 second)?

-dean
