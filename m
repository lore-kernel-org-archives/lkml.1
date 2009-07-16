Return-Path: <linux-kernel-owner+w=401wt.eu-S933632AbZGPXn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbZGPXn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933620AbZGPXn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:43:26 -0400
Received: from tundra.namei.org ([65.99.196.166]:36953 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933555AbZGPXnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:43:25 -0400
Date: Fri, 17 Jul 2009 09:41:41 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -mm 2/2] current_is_single_threaded: don't use
 ->mmap_sem
In-Reply-To: <20090713235612.GA4361@redhat.com>
Message-ID: <alpine.LRH.2.00.0907170940580.4687@tundra.namei.org>
References: <20090710014857.GC4723@redhat.com> <20090709212847.GA10238@redhat.com> <20090710013322.GA27719@infradead.org> <25973.1247234862@redhat.com> <alpine.LRH.2.00.0907130811380.29074@tundra.namei.org> <20090713235612.GA4361@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009, Oleg Nesterov wrote:

> > I gather this stuff is going into -mm ?
> 
> Yes, this is on top of rework-fix-is_single_threaded.patch
> 
> Given that David acked these changes, I guess they will go
> to -mm soon.
> 
> > Can it be merged via security-testing#next?
> 
> Please do what you think right, I don't know what will be more
> convenient to you and Andrew.

I've applied all three patches to

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

Oleg, please verify that they're the correct versions.


-- 
James Morris
<jmorris@namei.org>
