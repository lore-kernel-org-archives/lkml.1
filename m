Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbXHISog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbXHISog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbXHISoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:44:24 -0400
Received: from namei.org ([69.55.235.186]:41313 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751621AbXHISoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:44:22 -0400
X-Greylist: delayed 1599 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Aug 2007 14:44:22 EDT
Date: Thu, 9 Aug 2007 11:42:53 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] CacheFiles: Permit an inode's security ID to be
 obtained [try #2]
In-Reply-To: <21381.1186683681@redhat.com>
Message-ID: <Pine.LNX.4.64.0708091139310.19611@us.intercode.com.au>
References: <Pine.LNX.4.64.0708091114180.19611@us.intercode.com.au>
 <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com>
 <20070809160535.17906.59852.stgit@warthog.cambridge.redhat.com>
 <21381.1186683681@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, David Howells wrote:

> James Morris <jmorris@namei.org> wrote:
> 
> > > +	u32 (*inode_get_secid)(struct inode *inode);
> > 
> > To maintain API consistency, please return an int which only acts as an 
> > error code, and returning the secid via a *u32 function parameter.
> 
> Does that apply to *all* the functions, irrespective of whether or not they
> return an error?

LSM is theoretically an API, so we generally don't know if a security 
module will return an error or not.

If they were simply calls directly into SElinux, where we could always 
know the semantics, then that would be a different story.



- James
-- 
James Morris
<jmorris@namei.org>
