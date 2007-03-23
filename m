Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbXCWOQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbXCWOQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbXCWOQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:16:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53535 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbXCWOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:16:35 -0400
Date: Fri, 23 Mar 2007 15:16:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <christoph@lameter.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] NUMA : could we introduce virt_to_nid() ?
Message-ID: <20070323141633.GD20548@one.firstfloor.org>
References: <20070321102231.7288f231.dada1@cosmosbay.com> <84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com> <Pine.LNX.4.64.0703210742080.1573@graphe.net> <Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI> <20070321160929.GB25583@one.firstfloor.org> <20070323121512.c287ddef.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323121512.c287ddef.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 12:15:12PM +0100, Eric Dumazet wrote:
> Hi Andi
> 
> Checking Christoph quicklist implementation, I found the same cache miss in free() than SLAB has.
> 
> /* common implementation *
> int virt_to_nid(const void *addr)
> {
> 	struct page *page = virt_to_page(addr); 
> 	return page_to_nid(page);
> }
> 
> On some platforms (x86_64 for example), could we have a better implementation, not accessing struct page, but using phys_to_nid() ?

Sure why not. Please send a patch.

-Andi
