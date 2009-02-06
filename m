Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZBFIAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZBFIAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbZBFH7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:59:51 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:44056 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbZBFH7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:59:49 -0500
Date: Fri, 6 Feb 2009 08:59:45 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mel@csn.ul.ie, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: HOLES_IN_ZONE...
Message-ID: <20090206085945.17aed03e@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090205.154403.200370311.davem@davemloft.net>
References: <20090204.222651.26527737.davem@davemloft.net>
	<20090205090016.6197d588@osiris.boeblingen.de.ibm.com>
	<20090205.154403.200370311.davem@davemloft.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Feb 2009 15:44:03 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> > Later I reduced MAX_ORDER to 9 on s390, so we don't leave large
> > portions of memory unused.
> 
> Isn't is easier to just make sure your vmemmap mappings extend to such
> boundaries, whether they contain available memory or not?
> 
> That's the only requirement you have to satisfy to avoid having to
> specify HOLES_IN_ZONE.  You don't have to have memory there, just
> some vmmemmap page structs have to be mapped at those indices.
> 
> And then you won't need waste memory with these MAX_ORDER boundary
> adjustments.

Sounds reasonable. Back then I was under the impression that it is not
sufficient to only have a struct page but also a page for each PFN.
I'll give it a try as soon as time permits.

Thanks!
