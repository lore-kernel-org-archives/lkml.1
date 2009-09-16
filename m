Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZIPIET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZIPIET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbZIPIER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:04:17 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:52061 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbZIPIEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:04:14 -0400
Date: Wed, 16 Sep 2009 10:04:04 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org, mingo@elte.hu,
       npiggin@suse.de, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090916080404.GC4870@osiris.boeblingen.de.ibm.com>
References: <1253083059.5478.1.camel@penberg-laptop>
 <alpine.DEB.1.00.0909152351510.13366@chino.kir.corp.google.com>
 <1253084468.6749.27.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253084468.6749.27.camel@penberg-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 10:01:08AM +0300, Pekka Enberg wrote:
> On Wed, 16 Sep 2009, Pekka Enberg wrote:
> > > The SLQB allocator is known to be broken on certain PowerPC and S390
> > > configurations. Disable the allocator in Kconfig for those architectures
> > > until the issues are resolved.

Looks ok to me. I'll debug s390 when time permits.

> > >  init/Kconfig |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/init/Kconfig b/init/Kconfig
> > > index c0d8a47..aaeddeb 100644
> > > --- a/init/Kconfig
> > > +++ b/init/Kconfig
> > > @@ -1033,6 +1033,7 @@ config SLUB
> > >  
> > >  config SLQB
> > >  	bool "SLQB (Queued allocator)"
> > > +	depends on !PPC && !S390
> > >  	help
> > >  	  SLQB is a proposed new slab allocator.
> > >  
> 
> On Tue, 2009-09-15 at 23:55 -0700, David Rientjes wrote:
> > I think this should be (!PPC && !S390) || EXPERIMENTAL so that it can 
> > still be enabled for debugging and development.
> 
> Everybody enables EXPERIMENTAL so that seems pointless. Developers can
> hack Kconfig locally, no?

Exactly.
