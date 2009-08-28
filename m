Return-Path: <linux-kernel-owner+w=401wt.eu-S1752074AbZH1Quy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbZH1Quy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZH1Quy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:50:54 -0400
Received: from mail2.shareable.org ([80.68.89.115]:41233 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZH1Qux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:50:53 -0400
Date: Fri, 28 Aug 2009 17:50:49 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090828165049.GC8036@shareable.org>
References: <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <20090828164432.GA8036@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828164432.GA8036@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> That's because this thread is the first time I've heard that Linux
> O_SYNC was really the weaker O_DSYNC in disguise, and judging from the
> many Googlings I've done about O_SYNC in applications and on different
> OS, it'll be news to other people too.
> 
> (I always thought the "#define O_DSYNC O_SYNC" was because Linux
> didn't implement the weaker O_DSYNC).

It looks like we're not the only ones.  AIX has:

http://publib.boulder.ibm.com/infocenter/systems/index.jsp?topic=/com.ibm.aix.genprogc/doc/genprogc/fileio.htm

    Before the O_DSYNC open mode existed, AIX applied O_DSYNC semantics to
    O_SYNC. For binary compatibility reasons, this behavior still
    exists. If true O_SYNC behavior is required, then both O_DSYNC and
    O_SYNC open flags must be specified. Exporting the XPG_SUS_ENV=ON
    environment variable also enables true O_SYNC behavior.

-- Jamie
