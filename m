Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbZB0ATc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbZB0ATc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759722AbZB0ATO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:19:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44786 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbZB0ATN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:19:13 -0500
Date: Thu, 26 Feb 2009 19:19:09 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: filesystem time stamp resolution
Message-ID: <20090227001909.GA23258@infradead.org>
References: <49A7232C.6050808@redhat.com> <20090226235400.GP28946@ZenIV.linux.org.uk> <49A72C78.1060306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A72C78.1060306@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 03:57:44PM -0800, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Al Viro wrote:
> > Who said that it's not going to be dependent on the flags used to
> > create and/or mount the filesystem?  IOW, what makes you think that
> > knowing fs type will be enough to derive that data from?
> 
> Nothing.  Just the hope that the sanity of the users is a concern when
> these features are designed.
> 
> Regardless, we need some sort of solution.  I just looked, there is
> spare room in the kstatfs structure.  We could have a value returned in
> a new f_tsres field or so.  That could be per mount point.

Or finally get a pathconf syscall and inode operation..

