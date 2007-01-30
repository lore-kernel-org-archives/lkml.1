Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXA3Klh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXA3Klh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933160AbXA3Klg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:41:36 -0500
Received: from verein.lst.de ([213.95.11.210]:36560 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933159AbXA3Klg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:41:36 -0500
Date: Tue, 30 Jan 2007 11:41:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for	profiling Cell BE SPUs -- update
Message-ID: <20070130104120.GB14571@lst.de>
References: <45BE4ED0.5030808@us.ibm.com> <45BE4FA4.9020105@us.ibm.com> <200701300839.05144.arnd@arndb.de> <1170143630.26655.326.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170143630.26655.326.camel@localhost.localdomain>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 06:53:50PM +1100, Benjamin Herrenschmidt wrote:
> 
> > > +/* Defines used for sync_start */
> > > +#define SKIP_GENERIC_SYNC 0
> > > +#define SYNC_START_ERROR -1
> > > +#define DO_GENERIC_SYNC 1
> > > +
> > > +typedef struct vma_map
> > > +{
> > > +       struct vma_map *next;
> > > +       unsigned int vma;
> > > +       unsigned int size;
> > > +       unsigned int offset;
> > > +       unsigned int guard_ptr;
> > > +       unsigned int guard_val;
> > > +} vma_map_t;
> 
> I haven't had time to look in details yet but in that context, what does
> "vma" stands for ? There's already an important vm data structure in
> linux routinely called "vma" and thus I suspect this is a poor naming
> choice as it will cause confusion.

It looks like it actually is dealing with vma to me.  But then again:

 - please don't use typedefs for structures
 - there might be a more descriptive name for this than just vma_map
