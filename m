Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbXFQD2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbXFQD2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 23:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbXFQD21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 23:28:27 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:51818 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbXFQD20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 23:28:26 -0400
Date: Sun, 17 Jun 2007 12:26:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       trond.myklebust@fys.uio.no, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] NFS: Make NFS root work again
Message-ID: <20070617032656.GB6922@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
	trond.myklebust@fys.uio.no, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20070607164003.24322.51086.stgit@warthog.cambridge.redhat.com> <20070616091514.8e5dc1d3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070616091514.8e5dc1d3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 09:15:14AM -0700, Andrew Morton wrote:
> On Thu, 07 Jun 2007 17:40:03 +0100 David Howells <dhowells@redhat.com> wrote:
> > Make NFS root work by creating a "/root" directory to satisfy the mount,
> > otherwise the path lookup for the mount fails with ENOENT.
> > 
> 
> Am still awaiting a proper description of this patch, please.
> 
> What is not working, and how does this patch fix it?
> 
> I am unaware of any open bug reports against NFS root.

I've not had any problems with it during any of the -rc periods, for what
it's worth.
