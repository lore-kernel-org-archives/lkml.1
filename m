Return-Path: <linux-kernel-owner+w=401wt.eu-S1764172AbZDBQDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764172AbZDBQDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763986AbZDBQDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:03:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37591 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763959AbZDBQDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:03:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <49D4DA7E.7010508@redhat.com>
References: <49D4DA7E.7010508@redhat.com> <20090401230321.28177.12010.stgit@warthog.procyon.org.uk> <20090401230515.28177.73948.stgit@warthog.procyon.org.uk>
To: Peter Staubach <staubach@redhat.com>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of data to an inode [ver #46]
Date: Thu, 02 Apr 2009 17:03:16 +0100
Message-ID: <6509.1238688196@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Staubach <staubach@redhat.com> wrote:

> > +	.write_one_page		= generic_file_buffered_write_one_page,
> > +	.write_one_page		= generic_file_buffered_write_one_page,
> >   
> 
> You probably only need one of these lines, don't you?

Yes: one should be in ext2_aops, thanks.

David
