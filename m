Return-Path: <linux-kernel-owner+w=401wt.eu-S1763998AbXJOMyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763998AbXJOMyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 08:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759595AbXJOMyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 08:54:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50947 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759572AbXJOMyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 08:54:09 -0400
Date: Mon, 15 Oct 2007 14:54:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs@oss.sgi.com,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?iso-8859-1?B?QsO4Z2Vza292?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071015125407.GA13329@one.firstfloor.org>
References: <470FA7C3.90404@goop.org> <200710160056.47458.nickpiggin@yahoo.com.au> <20071015110735.GA11748@one.firstfloor.org> <200710152128.10900.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710152128.10900.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, OK. It looks like DRM vmallocs memory (which gives highmem).

I meant I'm not sure if it uses that memory uncached. I admit
not quite understanding that code. There used to be at least
one place where it set UC for an user mapping though.

-Andi
