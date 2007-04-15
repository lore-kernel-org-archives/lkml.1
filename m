Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXDODk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXDODk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 23:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbXDODk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 23:40:27 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:24816 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXDODk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 23:40:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P8QAqV627tDnc+sYpqGxqpNhGasl8GRKGRxp8Qoahe8NxlJYjjfa1GUx/CKmK3+kwQebp8FdckVtkj7cKDt8ZsbrNVV8xwDiwLe8z5sgp4M90MOVsvF/1fKH4rwTycq1GNxQfdRypV9n5jX1ptSl1ipzVGw/pg6L8qZ2f9r3RiI=
Message-ID: <170fa0d20704142040w204a715bgf5ce772e67126bbd@mail.gmail.com>
Date: Sat, 14 Apr 2007 23:40:24 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Subject: Re: [NFS] Merge plans for RPC/RDMA? (Was: Re: [PATCH 000 of 14] knfsd: Preparation for IPv6 support in NFS server.)
Cc: chuck.lever@oracle.com, NeilBrown <neilb@suse.de>,
       "Andrew Morton" <akpm@osdl.org>, "Roland Dreier" <rdreier@cisco.com>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jlentini@netapp.com, Thomas.Talpey@netapp.com, ogerlitz@voltaire.com
In-Reply-To: <1176502465.6394.26.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <170fa0d20704131347u4a28b5d1h1959227980449fbf@mail.gmail.com>
	 <1176502465.6394.26.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/07, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> On Fri, 2007-04-13 at 16:47 -0400, Mike Snitzer wrote:
> > I must be missing something because I don't see _any_ trace of the
> > core RPC over RDMA support (xprtrdma et al), your RPC Transport
> > Switch, or any of the other supporting changes in mainline.  Could
> > you, or others, please clarify the plan for merging RPC/RDMA?
>
> That would be a question for the actual RPC/RDMA developers (i.e. James
> Lentini and Tom Talpey). They haven't submitted any code for review yet.

The reason I asked is there seems to be a catch-22 going on here if
(as Chuck indicated) the NetApp engineers are waiting for the
remaining rpc transport switch patches to be merged.  My naive
understanding is that those remaining transport switch patches aren't
_really_ needed without the RPC/RDMA patches.

Essentially I'm echoing Or Gerlitz's post to openib-general back in December:
http://lists.openfabrics.org/pipermail/general/2006-December/029721.html

If so, it begs the question: why the hold up from the NetApp
engineers?  In the hopes of getting some insight I've cc'd James
Lentini and Tom Talpey.

I'm assuming that all of you obviously want your code merged mainline.
 The thing that is puzzling is the non-traditional release management
of this RPC/RDMA and NFS/RDMA code.  Aside from the periodic
announcements of the tarball updates to the sf.net nfs-rdma project;
I've not found any posting/discussion of associated patches to the
various mailing lists (nfs, nfsv4, ofa's general, lkml, etc).

I'm interested in understanding why the reluctance to push for a merge
now (let alone some months ago) given the various successes that have
been seen with the NFS/RDMA effort (Sandia, SC '06, as Chuck noted:
good performance at various test sites).  If the code is holding up
well why the delay in review and merging?  And rather than wait for
the remaining transport switch patches; why not look to merge all of
NFS/RDMA (client) work at the same time?

regards,
Mike
