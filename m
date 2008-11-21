Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYKUSbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYKUSbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYKUSbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:31:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750794AbYKUSbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:31:23 -0500
Date: Fri, 21 Nov 2008 10:31:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 24/45] CacheFiles: Add a hook to write a single page of
 data to an inode [ver #41]
Message-Id: <20081121103101.877506e3.akpm@linux-foundation.org>
In-Reply-To: <3843.1227271421@redhat.com>
References: <20081121002317.69e4fd11.akpm@linux-foundation.org>
	<20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
	<20081120144343.10667.530.stgit@warthog.procyon.org.uk>
	<3843.1227271421@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 12:43:41 +0000 David Howells <dhowells@redhat.com> wrote:

> > > +/**
> > > + * generic_file_buffered_write_one_page - Write a single page of data to an
> > > + *	inode
> > 
> > kerneldoc doesn't permit line breaks in this context (unless it got
> > fixed recently)
> 
> So you advocate a line exceeding 80 chars?

yup

> I contend that kerneldoc is a bad idea in many ways: it encourages people to
> be lazy and to not write proper interface documentation.

yes, for some reason kereldoc-formatted comments usually aren't very
useful.  They very often just don't convey useful insights.  I wonder
why.  Maybe people think that once they've filled out the form and
ticked all the boxes, they're done.

