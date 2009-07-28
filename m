Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbZG1HjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbZG1HjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbZG1HjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:39:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:34745 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZG1HjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:39:23 -0400
Subject: Re: [PATCH] mm: Make it easier to catch NULL cache names
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.0907272200520.22207@chino.kir.corp.google.com>
References: <1248745735.30993.38.camel@pasglop>
	 <alpine.LFD.2.01.0907271951390.3186@localhost.localdomain>
	 <1248749739.30993.39.camel@pasglop>
	 <alpine.DEB.2.00.0907272200520.22207@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 17:39:10 +1000
Message-Id: <1248766750.30993.51.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 22:01 -0700, David Rientjes wrote:
> On Tue, 28 Jul 2009, Benjamin Herrenschmidt wrote:
> 
> > > Please don't do BUG_ON() when there are alternatives.
> > > 
> > > In this case, something like
> > > 
> > > 	if (WARN_ON(!name))
> > > 		return NULL;
> > > 
> > > would probably have worked too.
> > 
> > Fair enough..  I'll send a new patch.
> > 
> 
> Actually needs goto err, not return NULL, to appropriately panic when 
> SLAB_PANIC is set.

Rats ! Why is it the trivial ones that are sooo hard :-)

New patch will have to wait til tomorrow, on my way home now.

Cheers,
Ben.


