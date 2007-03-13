Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbXCMX6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbXCMX6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 19:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXCMX6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 19:58:20 -0400
Received: from ozlabs.org ([203.10.76.45]:60722 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbXCMX6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 19:58:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17911.14998.938879.432788@cargo.ozlabs.ibm.com>
Date: Wed, 14 Mar 2007 10:58:14 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, clameter@sgi.com,
       linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
In-Reply-To: <20070313035250.f908a50e.akpm@linux-foundation.org>
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
	<20070313005334.853559ca.akpm@linux-foundation.org>
	<45F65ADA.9010501@yahoo.com.au>
	<20070313035250.f908a50e.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> Plus, we can get in a situation where take a cache-cold, known-zero page
> from the pte quicklist when there is a cache-hot, non-zero page sitting in
> the page allocator.  I suspect that zeroing the cache-hot page would take a
> similar amount of time to a single miss agains the cache-cold page.

That is certainly the case on powerpc.

> I'm not saying that I _know_ that the quicklists are pointless, but I don't
> think it's established that they are pointful.

I don't see much point to them.  For powerpc, I would rather grab an
arbitrary page and zero it than get a page off a quicklist.

> Maybe, dunno.  It was apparently a win on powerpc many years ago.  I had a

My recollection was that it wasn't a win, but it was a long time ago...

Paul.
