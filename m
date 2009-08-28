Return-Path: <linux-kernel-owner+w=401wt.eu-S1751264AbZH1Xqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbZH1Xqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 19:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZH1Xqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 19:46:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZH1Xqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 19:46:35 -0400
Date: Fri, 28 Aug 2009 19:46:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ulrich Drepper <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090828234631.GA28506@infradead.org>
References: <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <20090828230623.GD8036@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828230623.GD8036@shareable.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 12:06:23AM +0100, Jamie Lokier wrote:
> Christoph Hellwig wrote:
> >  - given that our current O_SYNC really is and always has been actuall
> >    Posix O_DSYNC
> 
> Are you sure about this?
> 
> >From http://www-01.ibm.com/support/docview.wss?uid=isg1IZ01704 :
> 
>     Error description
> 
>        LINUX O_DIRECT/O_SYNC TAKES TOO MANY IOS

That is for GPFS, and out of tree filesystem with binary components.
It could be that they took linux O_SYNC for real O_SYNC.  Any filesystem
using the generic helpers in Linux has gotten the O_DSYNC semantics at
least as long as I have worked on Linux filesystems, which is getting
close to 10 years now.  I'll do some code archaelogy before we'll move
with this to be sure.

