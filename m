Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbXEET1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbXEET1F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 15:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933213AbXEET1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 15:27:05 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46093 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187AbXEET1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 15:27:03 -0400
Date: Sat, 5 May 2007 15:23:35 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       jsipek@cs.sunysb.edu, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, unionfs@filesystems.org
Subject: Re: [-mm patch] fix unionfs compilation
Message-ID: <20070505192335.GC5834@filer.fsl.cs.sunysb.edu>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <20070505170012.GF8975@stusta.de> <20070505115718.a1a0b61e.akpm@linux-foundation.org> <84144f020705051219m15d3828bp6e4697c74a3005ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020705051219m15d3828bp6e4697c74a3005ce@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 10:19:42PM +0300, Pekka Enberg wrote:
> On 5/5/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >Bah, that was hidden from my allmodconfig because CONFIG_UNIONFS is 
> >inexplicably
> >dependent upon CONFIG_SLAB.
> >
> >How come?
> 
> I think Adrian added it before we introduced krealloc() to fix uniofs
> from poking slab internals.

I believe the (commented out) patch in -mm series file fixes things:

	unionfs-fix-slab-abuses-with-krealloc.patch

It probably got commented out when unionfs got temporarily dropped from -mm.

Josef "Jeff" Sipek.

-- 
Keyboard not found!
Press F1 to enter Setup
