Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbZFKO13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbZFKO13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZFKO1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:27:22 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:58106 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751923AbZFKO1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:27:21 -0400
Date: Thu, 11 Jun 2009 10:26:55 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hannes@cmpxchg.org, mingo@elte.hu, mpm@selenic.com, npiggin@suse.de,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early boot SLAB for 2.6.31
In-Reply-To: <84144f020906110706y8df301bhd930dc48f3188d3c@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0906111024510.29827@gentwo.org>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI>  <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>  <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain>  <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI> 
 <alpine.DEB.1.10.0906110954030.29827@gentwo.org> <84144f020906110706y8df301bhd930dc48f3188d3c@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Pekka Enberg wrote:

> > This function is also called later when kmalloc caches are
> > created on demand.
>
> Where? AFAICT, only kmem_cache_init() calls the function.

Right. I thought dma_kmalloc_cache would also call this but it open codes
create_kmalloc_cache due to the need to trylock on slub_lock.


