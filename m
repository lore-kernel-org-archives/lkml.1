Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbZAFXQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbZAFXQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbZAFXQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:16:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755715AbZAFXP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:15:59 -0500
Date: Tue, 6 Jan 2009 15:15:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Michael Halcrow <mhalcrow@us.ibm.com>,
       ecryptfs-devel@lists.launchpad.net
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090106151534.9e9205bc.akpm@linux-foundation.org>
In-Reply-To: <20090106225744.GA10553@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106225744.GA10553@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Tue, 6 Jan 2009 17:57:44 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> 
> > ecryptfs-filename-encryption-tag-70-packets.patch
> > ecryptfs-filename-encryption-header-updates.patch
> > ecryptfs-filename-encryption-encoding-and-encryption-functions.patch
> > ecryptfs-filename-encryption-filldir-lookup-and-readlink.patch
> > ecryptfs-filename-encryption-mount-option.patch
> > ecryptfs-replace-%z-with-%z.patch
> > ecryptfs-fix-data-types-int-size_t.patch
> > ecryptfs-kerneldoc-for-ecryptfs_parse_tag_70_packet.patch
> > ecryptfs-clean-up-ecryptfs_decode_from_filename.patch
> > fs-ecryptfs-inodec-cleanup-kerneldoc.patch
> 
> By using lookup_one_len on an arbitrary underlying filesystem this
> breaks the assumption that a nameidata is always available.  Please
> redo to use proper lookup helpers.

It that a nack, or do we think we can address this in the next week or
three?

>  Also whole code feels rather
> fragile from a 10000 feet view, but beeing plsit in so many
> patches it's almost impossible to properly review it anywya.
> 

Yes, it made my brain hurt.

