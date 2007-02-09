Return-Path: <linux-kernel-owner+w=401wt.eu-S1946007AbXBIBoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946007AbXBIBoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 20:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946006AbXBIBoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 20:44:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:35757 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946007AbXBIBog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 20:44:36 -0500
Subject: Re: [patch 0/3] 2.6.20 fix for PageUptodate memorder problem (try
	2)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@osdl.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070209013115.GA17334@wotan.suse.de>
References: <20070208111421.30513.77904.sendpatchset@linux.site>
	 <Pine.LNX.4.64.0702090027580.29905@blonde.wat.veritas.com>
	 <20070209013115.GA17334@wotan.suse.de>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 12:44:09 +1100
Message-Id: <1170985449.2620.391.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Fix threaded user page write memory ordering
> 
> Thanks, I did see that, but I'm sure it must have been prompted by a
> discussion or another proposed patch from IBM. Maybe I'm wrong
> though.

Yes, my initial proposal iirc was to smp_wmb() in set_pte() but after a
discussion with Linus, we ended with open coding them.

Ben.


