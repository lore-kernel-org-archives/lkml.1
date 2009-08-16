Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZHPFMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZHPFMD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 01:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZHPFMC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 01:12:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbZHPFMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 01:12:01 -0400
Date: Sun, 16 Aug 2009 07:12:01 +0200
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [patch 4a/4] ipc: sem optimise simple operations
Message-ID: <20090816051201.GA17920@wotan.suse.de>
References: <200908141946.n7EJkh7B018160@mail.q-ag.de> <20090815045237.GC19195@wotan.suse.de> <4A86899A.6050502@colorfullife.com> <20090815103820.GC8954@wotan.suse.de> <4A86ABF0.2070207@colorfullife.com> <20090815144908.GA30951@wotan.suse.de> <4A86E30E.8030208@colorfullife.com> <20090816045316.GA11115@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090816045316.GA11115@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 06:53:16AM +0200, Nick Piggin wrote:
> On Sat, Aug 15, 2009 at 06:32:14PM +0200, Manfred Spraul wrote:
> > Lower runtime memory consumption.
> 
> I'll fix this with hlists.

Oh right no the negv list can't easily be made an hlist. So
yes yours can save a bit of memory there.

