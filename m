Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYLRXHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYLRXHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYLRXHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:07:39 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48280 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753455AbYLRXHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:07:38 -0500
X-Sasl-enc: W7XuJ+uOdCS8MC4EPJ0W8raou5cGECUxKW9kMR742JCL 1229641656
From: Bernd Schubert <bernd.schubert@fastmail.fm>
To: nfsv4@linux-nfs.org
Subject: Re: Pull request for FS-Cache, including NFS patches
Date: Fri, 19 Dec 2008 00:07:33 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc5-bs4-00019-ge14c8bf; KDE/4.1.3; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, steved@redhat.com, dhowells@redhat.com,
       linux-fsdevel@vger.kernel.org, rwheeler@redhat.com
References: <8930.1229560221@redhat.com> <20081218142420.GA16728@infradead.org> <20081218123601.11810b7f.akpm@linux-foundation.org>
In-Reply-To: <20081218123601.11810b7f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812190007.34581.bernd.schubert@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2008, Andrew Morton wrote:
> On Thu, 18 Dec 2008 09:24:20 -0500
>
> Christoph Hellwig <hch@infradead.org> wrote:
> > On Thu, Dec 18, 2008 at 10:44:18PM +1100, Stephen Rothwell wrote:
> > > Added from today.
> > >
> > > Usual spiel: all patches in that branch must have been
> > > 	posted to a relevant mailing list
> > > 	reviewed
> > > 	unit tested
> > > 	destined for the next merge window (or the current release)
> > > *before* they are included.
> >
> > I don't think we want fscache for .29 yet.  I'd rather let the
> > credential code settle for one release, and have more time for actually
> > reviewing it properly and have it 100% ready for .30.
>
> I don't believe that it has yet been convincingly demonstrated that we
> want to merge it at all.
>
> It's a huuuuuuuuge lump of new code, so it really needs to provide
> decent value.  Can we revisit this?  Yet again?  What do we get from
> all this?
>

I really don't understand why fs-cache is always rejected. Actually it is the 
perfect solution for NFS booted systems - you have a big cluster of nodes and 
in order to minimize administration overhead the nodes are booted over NFS 
from one common chroot. With unionfs (preferred solution here is unionfs-fuse) 
one then maintains files required to be differently by different clients.

Caching files on the local disk minimized the network access and boosts the 
performance, so at least for this usage example fs-cache would be great.
(Actually I have been thinking about to implement a caching branch into 
unionfs-fuse, but if the kernel can do it on its own, it is also fine.)

In the past David already posted many benchmarks and just a few weeks ago 
again:

http://lkml.indiana.edu/hypermail/linux/kernel/0811.3/00584.html


Cheers,
Bernd


