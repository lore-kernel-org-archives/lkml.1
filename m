Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbXIURB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbXIURB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbXIURBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:01:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbXIURBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:01:50 -0400
Message-ID: <46F3F8BF.1030404@redhat.com>
Date: Fri, 21 Sep 2007 13:00:47 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070718)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 14/22] NFS: Use local caching
References: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk> <20070921144815.8323.77745.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070921144815.8323.77745.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> The attached patch makes it possible for the NFS filesystem to make use of the
> network filesystem local caching service (FS-Cache).
>
> To be able to use this, an updated mount program is required.  This can be
> obtained from:
>
> 	http://people.redhat.com/steved/fscache/util-linux/
>
> To mount an NFS filesystem to use caching, add an "fsc" option to the mount:
>
> 	mount warthog:/ /a -o fsc
>
> Signed-Off-By: David Howells <dhowells@redhat.com>
> ---

Did I miss the section where the modified semantics about which
mounted file systems can use the cache and which ones can not
was implemented?  For example, mounts of the same file system
from the server with "fsc", but with different mount options
such as "rw" or "ro" or NFS dependent mount options, must fail
because of the way that the cache is accessed.  Also, perhaps
a little confusing, that mounts of different paths on a server
which land on the same mounted file system on the server, but
with these differing mount options must also fail?

    Thanx...

       ps
