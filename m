Return-Path: <linux-kernel-owner+w=401wt.eu-S1751438AbZH2A7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbZH2A7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 20:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZH2A7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 20:59:31 -0400
Received: from mail2.shareable.org ([80.68.89.115]:48356 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbZH2A7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 20:59:31 -0400
Date: Sat, 29 Aug 2009 01:59:21 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090829005921.GE8036@shareable.org>
References: <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <4A98008B.6050503@redhat.com> <20090828161745.GA8755@infradead.org> <4A9806D9.5050409@redhat.com> <20090828164657.GB8036@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828164657.GB8036@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Ulrich Drepper wrote:
> > >  - O_RSYNC basically means we need to commit atime updates before a
> > >    read returns, right?
> > 
> > No, that's not it.
> > 
> > O_RSYNC on its own just means the data is successfully transferred to 
> > the calling process (always the case).
> > 
> > O_RSYNC|O_DSYNC means that if a read request hits data that is currently 
> > in a cache and not yet on the medium, then the write to medium is 
> > successful before the read succeeds.
> > 
> > O_RSYNC|O_SYNC means the same plus the integrity of file meta 
> > information (access time etc).
> 
> On several unixes, O_RSYNC means it will send the read to the
> hardware, not relying on the cache.  This can be used to verify the
> data which was written earlier, whether by O_DSYNC or fdatasync.

I'm sure I read that in a couple of OS man pages, but I can't find it
again.  Maybe it was something more obscure than the mainstream
unices; maybe I imagined it.  Ho hum.  For now, forget I said anythng.

-- Jamie
