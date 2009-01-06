Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbZAFCaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbZAFCaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZAFCaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:30:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044AbZAFCaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:30:05 -0500
Date: Mon, 5 Jan 2009 18:29:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Klotz <peter.klotz@aon.at>, stable@kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Kononov <kernel@kononov.ftml.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re: BUG:
 soft lockup - is this XFS problem?)
In-Reply-To: <20090106020550.GA819@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0901051829080.3057@localhost.localdomain>
References: <20090105041959.GC367@wotan.suse.de> <20090105064838.GA5209@wotan.suse.de> <49623384.2070801@aon.at> <20090105164135.GC32675@wotan.suse.de> <alpine.LFD.2.00.0901050859430.3057@localhost.localdomain> <20090105180008.GE32675@wotan.suse.de>
 <alpine.LFD.2.00.0901051027011.3057@localhost.localdomain> <20090105201258.GN6959@linux.vnet.ibm.com> <alpine.LFD.2.00.0901051224110.3057@localhost.localdomain> <20090105215727.GQ6959@linux.vnet.ibm.com> <20090106020550.GA819@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2009, Nick Piggin wrote:
> 
> Sticking an rcu_dereference in radix_tree_deref_slot seems to fix the
> assembly for me too, I grafted the changelog onto that. Linus probably
> you are using -Os?

Ahh, yes. I am. That explains why I can't see any difference.

		Linus
