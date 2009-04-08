Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbZDHGYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbZDHGYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761843AbZDHGYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:24:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48509 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131AbZDHGYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:24:05 -0400
Date: Wed, 8 Apr 2009 08:26:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Russ Anderson <rja@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [2/16] POISON: Add page flag for poisoned pages
Message-ID: <20090408062621.GG17934@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407150958.BA68F1D046D@basil.firstfloor.org> <20090408002941.GA14041@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408002941.GA14041@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -104,6 +107,9 @@
> >  #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
> >  	PG_uncached,		/* Page has been mapped as uncached */
> >  #endif
> > +#ifdef CONFIG_MEMORY_FAILURE
> 
> Is it necessary to have this under CONFIG_MEMORY_FAILURE?

That was mainly so that !MEMORY_FAILURE 32bits NUMA architectures who
might not use sparsemap/vsparsemap get a few more zone bits in page flags
to play with. Not sure those really exist, so it might be indeed
redundant, but it seemed safer.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
