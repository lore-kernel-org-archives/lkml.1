Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbYDKKxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbYDKKxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759085AbYDKKxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:53:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36516 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759385AbYDKKxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:53:10 -0400
Date: Fri, 11 Apr 2008 19:57:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.25-rc8-mm2
Message-Id: <20080411195738.16e9ef92.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1207910058.7212.1.camel@haji>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
	<20080411185703.a5407940.kamezawa.hiroyu@jp.fujitsu.com>
	<20080411192346.6872472a.kamezawa.hiroyu@jp.fujitsu.com>
	<1207910058.7212.1.camel@haji>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 13:34:18 +0300
Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/
> > > > 
> > > > - Compilation is busted on mips due to the page-flags patches
> > > > 
> > > On ia64/NUMA box (which has empty nodes.)
> > > 
> > > CONFIG_SLAB ..... booted well
> > > CONFIG_SLUB ..... can't boot
> > > CONFIG_SLUB + CONFIG_SLUB_DEBUG_ON .... booted. Hmm?
> > > 
> > > I'll dig more if I can.
> > > 
> > with slub_nomerge , booted.
> 
> What happens when it doesn't boot? Does it hang or do you get an oops?
just hangs. before showing anything.


> Can you reproduce it with the 'for-mm' branch of:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git
> 

will try. 

Thanks,
-Kame

