Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbXENQaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbXENQaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbXENQaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:30:09 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38784 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754670AbXENQaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:30:07 -0400
X-Sasl-enc: GUeCRawybj4Rm++OHWkxBPYY3+HUlYjasQDMIljYaQnC 1179160206
Subject: Re: Read-only bind mount patches
From: Ian Kent <raven@themaw.net>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, haveblue@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org,
       Trond Myklebust <Trond.Myklebust@netapp.com>
In-Reply-To: <1179158480.366.8.camel@localhost.localdomain>
References: <1179148960.3811.33.camel@raven.themaw.net>
	 <1179155458.28670.22.camel@localhost.localdomain>
	 <1179158131.3811.59.camel@raven.themaw.net>
	 <1179158480.366.8.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 15 May 2007 00:29:59 +0800
Message-Id: <1179160199.3811.88.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 09:01 -0700, Dave Hansen wrote:
> On Mon, 2007-05-14 at 23:55 +0800, Ian Kent wrote:
> > 
> > Anything I can do to help?
> > If so maybe we could reduce the time to posting a bit.
> 
> Probably nothing to actually speed up the development, but I'd really
> appreciate some testing once I do post them.  How about I send you an
> advance copy, or cc you on the RFC?

Sure.

My personal test environment is limited.
I can test them with the autofs Connectathon suite and do sanity
checking and the like.

In my other life I can spin a RHEL5 kernel in a private branch and get
that to customers that are complaining, hopefully they will be willing
to test this stuff and persevere with any needed debugging (ya right).
I'm happy to screen reports before passing them on and hopefully provide
you with sensible feedback. But it would be best if we could at least
get this into the mm kernel. That should get them a fair bit of
exposure.

The other question for me is I don't know yet if this will resolve the
problem that lead me to chase this. That's the problem where all NFS
client mounts to the same exported filesystem always use the mount
options of the first mount.

Are you sure I can't help with development, even just re-spinning them
against the current kernel may help (of course you would know best).
Having read the patch set in the archives I see that I'm familiar with
the code in most of the areas of the VFS they touch (but maybe not to
the depth that I would like).

Ian


