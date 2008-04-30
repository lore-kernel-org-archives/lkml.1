Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYD3HqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYD3HqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbYD3HqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:46:00 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:8600 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434AbYD3Hp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:45:59 -0400
Date: Wed, 30 Apr 2008 09:45:56 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com
Subject: Re: sparc64 bootup regression...
Message-ID: <20080430074556.GA29363@osiris.boeblingen.de.ibm.com>
References: <20080429.231241.221824292.davem@davemloft.net> <20080429233832.168fb6ee.akpm@linux-foundation.org> <20080430161540.bfff2c45.kamezawa.hiroyu@jp.fujitsu.com> <20080430073052.GA11015@osiris.boeblingen.de.ibm.com> <20080430164444.b5b5e6aa.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430164444.b5b5e6aa.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 04:44:44PM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 30 Apr 2008 09:30:52 +0200
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > > +#endif
> > > +	/* above allocation can fail. */
> > > +	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
> > > +	if (usemap)
> > > +		return usemap;
> > > 
> > >  	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
> > >  	nid = 0;
> > 
> > Fixes it on s390 at least.
> > 
> Thanks, much help to understand what happens.
> BTW, s390 is CONFIG_NUMA or not ?

We don't set CONFIG_NUMA on s390.
