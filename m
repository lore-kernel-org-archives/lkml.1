Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbYHEEDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbYHEEDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbYHEECg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:02:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:42608 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbYHEECf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:02:35 -0400
Subject: Re: Switching TestSetPageLocked to trylock_page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080804205754.b05c8aa9.akpm@linux-foundation.org>
References: <200807311726.51816.nickpiggin@yahoo.com.au>
	 <200808051314.33791.nickpiggin@yahoo.com.au>
	 <alpine.LFD.1.10.0808042024480.3299@nehalem.linux-foundation.org>
	 <200808051341.53282.nickpiggin@yahoo.com.au>
	 <20080804205754.b05c8aa9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 14:01:59 +1000
Message-Id: <1217908919.24157.148.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Yup.  A mechanical rename-foo-to-bar can be prepared and merged late -
> there's little payback for the pain of maintaining it for a couple of
> months.
> 
> Would prefer either that we hold off until after 2.6.27 is released or
> just do it now.

I'd like to have the performance improvement on powerpc in 2.6.27 :-)

I've always hated the way we abused bitops as locks, it's terribly
inefficient for us, so that's a nice cleanup as far as I'm concerned.

Cheers,
Ben.


