Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbZAGHys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbZAGHys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 02:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbZAGHyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 02:54:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43210 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740AbZAGHyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 02:54:33 -0500
Date: Wed, 7 Jan 2009 02:54:31 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Michael Halcrow <mhalcrow@us.ibm.com>,
       ecryptfs-devel@lists.launchpad.net
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090107075431.GA2457@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151534.9e9205bc.akpm@linux-foundation.org> <20090106232504.GD25103@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106232504.GD25103@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 06:25:04PM -0500, Christoph Hellwig wrote:
> On Tue, Jan 06, 2009 at 03:15:34PM -0800, Andrew Morton wrote:
> > > > ecryptfs-filename-encryption-tag-70-packets.patch
> > > > ecryptfs-filename-encryption-header-updates.patch
> > > > ecryptfs-filename-encryption-encoding-and-encryption-functions.patch
> > > > ecryptfs-filename-encryption-filldir-lookup-and-readlink.patch
> > > > ecryptfs-filename-encryption-mount-option.patch
> > > > ecryptfs-replace-%z-with-%z.patch
> > > > ecryptfs-fix-data-types-int-size_t.patch
> > > > ecryptfs-kerneldoc-for-ecryptfs_parse_tag_70_packet.patch
> > > > ecryptfs-clean-up-ecryptfs_decode_from_filename.patch
> > > > fs-ecryptfs-inodec-cleanup-kerneldoc.patch
> > > 
> > > By using lookup_one_len on an arbitrary underlying filesystem this
> > > breaks the assumption that a nameidata is always available.  Please
> > > redo to use proper lookup helpers.
> > 
> > It that a nack, or do we think we can address this in the next week or
> > three?
> 
> Together we the state of the rest of that code that's a NACK, yes :)

Umm, why did you you just push this in anyway without comment?
