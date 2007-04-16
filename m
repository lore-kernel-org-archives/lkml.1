Return-Path: <linux-kernel-owner+w=401wt.eu-S1030656AbXDPO2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030656AbXDPO2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030658AbXDPO2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:28:13 -0400
Received: from mx2.netapp.com ([216.240.18.37]:10308 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030656AbXDPO2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:28:12 -0400
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2007 10:28:12 EDT
X-IronPort-AV: i="4.14,415,1170662400"; 
   d="scan'208"; a="51592813:sNHT37944445"
Date: Mon, 16 Apr 2007 10:13:57 -0400 (EDT)
From: James Lentini <jlentini@netapp.com>
X-X-Sender: jlentini@jlentini-linux.nane.netapp.com
To: Mike Snitzer <snitzer@gmail.com>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>, chuck.lever@oracle.com,
       NeilBrown <neilb@suse.de>, Andrew Morton <akpm@osdl.org>,
       Roland Dreier <rdreier@cisco.com>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Tom Tucker <tom@opengridcomputing.com>,
       Thomas.Talpey@netapp.com, Or Gerlitz <ogerlitz@voltaire.com>
Subject: Re: [NFS] Merge plans for RPC/RDMA? (Was: Re: [PATCH 000 of 14]
 knfsd: Preparation for IPv6 support in NFS server.)
In-Reply-To: <170fa0d20704142040w204a715bgf5ce772e67126bbd@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704161002200.7869@jlentini-linux.nane.netapp.com>
References: <170fa0d20704131347u4a28b5d1h1959227980449fbf@mail.gmail.com> 
 <1176502465.6394.26.camel@heimdal.trondhjem.org>
 <170fa0d20704142040w204a715bgf5ce772e67126bbd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 16 Apr 2007 14:18:05.0515 (UTC) FILETIME=[0CD1E1B0:01C78032]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 14 Apr 2007, Mike Snitzer wrote:

> On 4/13/07, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > On Fri, 2007-04-13 at 16:47 -0400, Mike Snitzer wrote:
> > > I must be missing something because I don't see _any_ trace of the
> > > core RPC over RDMA support (xprtrdma et al), your RPC Transport
> > > Switch, or any of the other supporting changes in mainline.  Could
> > > you, or others, please clarify the plan for merging RPC/RDMA?
> > 
> > That would be a question for the actual RPC/RDMA developers (i.e. James
> > Lentini and Tom Talpey). They haven't submitted any code for review yet.
> 
> The reason I asked is there seems to be a catch-22 going on here if
> (as Chuck indicated) the NetApp engineers are waiting for the
> remaining rpc transport switch patches to be merged.  My naive
> understanding is that those remaining transport switch patches aren't
> _really_ needed without the RPC/RDMA patches.
> 
> Essentially I'm echoing Or Gerlitz's post to openib-general back in December:
> http://lists.openfabrics.org/pipermail/general/2006-December/029721.html
> 
> If so, it begs the question: why the hold up from the NetApp
> engineers?  In the hopes of getting some insight I've cc'd James
> Lentini and Tom Talpey.
> 
> I'm assuming that all of you obviously want your code merged mainline.
> The thing that is puzzling is the non-traditional release management
> of this RPC/RDMA and NFS/RDMA code.  Aside from the periodic
> announcements of the tarball updates to the sf.net nfs-rdma project;
> I've not found any posting/discussion of associated patches to the
> various mailing lists (nfs, nfsv4, ofa's general, lkml, etc).
> 
> I'm interested in understanding why the reluctance to push for a merge
> now (let alone some months ago) given the various successes that have
> been seen with the NFS/RDMA effort (Sandia, SC '06, as Chuck noted:
> good performance at various test sites).  If the code is holding up
> well why the delay in review and merging?  And rather than wait for
> the remaining transport switch patches; why not look to merge all of
> NFS/RDMA (client) work at the same time?

There is no reluctance to submit the NFS-RDMA code for review. There 
have been several upstream changes to the NFS server recently. We 
(NetApp and Tom Tucker at OGC) are working on a new patchset for 
NFS-RDMA that is compatible with these changes. We are testing the 
code now. 

We will post the patches for review when we finish updating them.
