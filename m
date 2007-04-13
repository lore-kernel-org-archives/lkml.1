Return-Path: <linux-kernel-owner+w=401wt.eu-S965280AbXDMUrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbXDMUrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965287AbXDMUrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:47:21 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:26721 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965280AbXDMUrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:47:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=IQq+lrHBqn5idKiFg1kY+6q4Dxw6WNCN3ci0TMG0SafsRnNMCSpV07sWPgSbZOCxWKJvw+1OJ2OfkpYrdK0FltSP2tFAJp6LE5flXushJmy+X7B5Ld7Zh+AvScZLcUu9AgqL3n+ByXPZ23KqrZfzo4oeOYlAcYqbGCaawKs8DwA=
Message-ID: <170fa0d20704131347u4a28b5d1h1959227980449fbf@mail.gmail.com>
Date: Fri, 13 Apr 2007 16:47:20 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: chuck.lever@oracle.com
Subject: Merge plans for RPC/RDMA? (Was: Re: [NFS] [PATCH 000 of 14] knfsd: Preparation for IPv6 support in NFS server.)
Cc: "Roland Dreier" <rdreier@cisco.com>, NeilBrown <neilb@suse.de>,
       "Andrew Morton" <akpm@osdl.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/07, Chuck Lever <chuck.lever@oracle.com> wrote:
> Roland Dreier wrote:
> >  > They are mostly from Chuck Level and make preparating for IPv6 support
> >  > in the NFS server.
> >  > They are *not* for 2.6.20, but should be ok for .21.
> >
> > Out of curiousity, does this patch series reduce the delta between the
> > NFS/RDMA tree and mainline Linux?  In other words does this bring
> > NFS/RDMA closer to merging?
>
> Hi Roland-
>
> The client side support for an RPC/RDMA module is almost completely
> integrated into mainline.  There is still a minimal set of patches
> required to support alternate transports in loadable kernel modules
> which Trond has indicated he will integrate when the RPC/RDMA transport
> is ready to be integrated.

Hi Chuck,

I must be missing something because I don't see _any_ trace of the
core RPC over RDMA support (xprtrdma et al), your RPC Transport
Switch, or any of the other supporting changes in mainline.  Could
you, or others, please clarify the plan for merging RPC/RDMA?

> At this time I'm not aware of a plan to integrate server-side support
> for NFS/RDMA.  Perhaps the NetApp RDMA developers could respond.

Do you mean the NFS/RDMA server code from Tom Tucker of Open Grid
Computing?  Why wouldn't this code be included?

please advise, thanks.
