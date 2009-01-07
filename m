Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbZAGIAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbZAGIAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 03:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZAGIAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 03:00:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594AbZAGIAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 03:00:17 -0500
Date: Tue, 6 Jan 2009 23:59:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Michael Halcrow <mhalcrow@us.ibm.com>,
       ecryptfs-devel@lists.launchpad.net
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090106235943.d23b27c2.akpm@linux-foundation.org>
In-Reply-To: <20090107075431.GA2457@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106225744.GA10553@infradead.org>
	<20090106151534.9e9205bc.akpm@linux-foundation.org>
	<20090106232504.GD25103@infradead.org>
	<20090107075431.GA2457@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009 02:54:31 -0500 Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Jan 06, 2009 at 06:25:04PM -0500, Christoph Hellwig wrote:
> > On Tue, Jan 06, 2009 at 03:15:34PM -0800, Andrew Morton wrote:
> > > > > ecryptfs-filename-encryption-tag-70-packets.patch
> > > > > ecryptfs-filename-encryption-header-updates.patch
> > > > > ecryptfs-filename-encryption-encoding-and-encryption-functions.patch
> > > > > ecryptfs-filename-encryption-filldir-lookup-and-readlink.patch
> > > > > ecryptfs-filename-encryption-mount-option.patch
> > > > > ecryptfs-replace-%z-with-%z.patch
> > > > > ecryptfs-fix-data-types-int-size_t.patch
> > > > > ecryptfs-kerneldoc-for-ecryptfs_parse_tag_70_packet.patch
> > > > > ecryptfs-clean-up-ecryptfs_decode_from_filename.patch
> > > > > fs-ecryptfs-inodec-cleanup-kerneldoc.patch
> > > > 
> > > > By using lookup_one_len on an arbitrary underlying filesystem this
> > > > breaks the assumption that a nameidata is always available.  Please
> > > > redo to use proper lookup helpers.
> > > 
> > > It that a nack, or do we think we can address this in the next week or
> > > three?
> > 
> > Together we the state of the rest of that code that's a NACK, yes :)
> 
> Umm, why did you you just push this in anyway without comment?

I'd sent them before you sent your comments.  I didn't think I had
done that, so I didn't mention it earlier.
