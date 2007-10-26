Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbXJZEdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbXJZEdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 00:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbXJZEcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 00:32:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:34331 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbXJZEcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 00:32:52 -0400
Subject: Re: [interesting] smattering of possible memory ordering bugs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, paulus@samba.org,
       shaggy@austin.ibm.com, adaplas@gmail.com,
       "Morton, Andrew" <akpm@linux-foundation.org>, xfs-masters@oss.sgi.com
In-Reply-To: <200710261347.35545.nickpiggin@yahoo.com.au>
References: <200710261209.58519.nickpiggin@yahoo.com.au>
	 <1193369717.7018.56.camel@pasglop>
	 <200710261347.35545.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 14:32:27 +1000
Message-Id: <1193373147.7018.70.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-26 at 13:47 +1000, Nick Piggin wrote:

> I don't think the previous code was wrong... it's not a locked section
> > and we don't care about ordering previous stores. It's an
> allocation, it
> > should be fine. In general, bitmap allocators should be allright.
> 
> Well if it is just allocating an arbitrary _number_ out of a bitmap
> and nothing else (eg. like the pid allocator), then you don't need
> barriers.

Yup, that's what it does.

Cheers,
Ben.


