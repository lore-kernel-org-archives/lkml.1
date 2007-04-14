Return-Path: <linux-kernel-owner+w=401wt.eu-S1030904AbXDNAEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030904AbXDNAEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 20:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030903AbXDNAEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 20:04:12 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:37811 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030904AbXDNAEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 20:04:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iwZQxVRCLOV4IZKcNofH77iICiszBTQXW7skEvOL+tHQ5JMlvFNa04x99rq5gnC6NBIDbURdd4r97ynvUyB3L+6sm2ffXmmxzleFI7x9s+d2cjYxFNpAPoVUWW54E9FLp/OezJa2UIpOd2/Kob5h0mDo0g8hivceU8AStHnX0Pw=
Message-ID: <170fa0d20704131704y13151149n817cd698e22781c8@mail.gmail.com>
Date: Fri, 13 Apr 2007 20:04:10 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: chuck.lever@oracle.com
Subject: Re: Merge plans for RPC/RDMA? (Was: Re: [NFS] [PATCH 000 of 14] knfsd: Preparation for IPv6 support in NFS server.)
Cc: "Roland Dreier" <rdreier@cisco.com>, NeilBrown <neilb@suse.de>,
       "Andrew Morton" <akpm@osdl.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <46200822.5060800@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <170fa0d20704131347u4a28b5d1h1959227980449fbf@mail.gmail.com>
	 <46200822.5060800@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/07, Chuck Lever <chuck.lever@oracle.com> wrote:
> Mike Snitzer wrote:
> > On 2/2/07, Chuck Lever <chuck.lever@oracle.com> wrote:
> >> Roland Dreier wrote:
> >> >  > They are mostly from Chuck Level and make preparating for IPv6
> >> support
> >> >  > in the NFS server.
> >> >  > They are *not* for 2.6.20, but should be ok for .21.
> >> >
> >> > Out of curiousity, does this patch series reduce the delta between the
> >> > NFS/RDMA tree and mainline Linux?  In other words does this bring
> >> > NFS/RDMA closer to merging?
> >>
> >> Hi Roland-
> >>
> >> The client side support for an RPC/RDMA module is almost completely
> >> integrated into mainline.  There is still a minimal set of patches
> >> required to support alternate transports in loadable kernel modules
> >> which Trond has indicated he will integrate when the RPC/RDMA transport
> >> is ready to be integrated.
> >
> > Hi Chuck,
> >
> > I must be missing something because I don't see _any_ trace of the
> > core RPC over RDMA support (xprtrdma et al), your RPC Transport
> > Switch, or any of the other supporting changes in mainline.  Could
> > you, or others, please clarify the plan for merging RPC/RDMA?
>
> The RPC transport switch patches are almost fully integrated into
> mainline.  The xprtrdma piece is what is not there yet.

OK, has the xprtrdma piece been reviewed by the community?  What, if
anything, is preventing the code from being included in -mm for wider
testing?

Has xprtrdma inclusion/progress been discussed on some other mailing
list?  Any insight would be appreciated.
