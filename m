Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbXDPOsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbXDPOsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXDPOsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:48:52 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:18890 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbXDPOsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:48:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K+gmP7nztuo1BpUie8SFpcJ3KyF+buy/ADEePJgEafOFtVlqKRZAdZ+x9XoG6L5WjTeSLQH1+gKPQfKoqax7vot4q3uxakT0bJMFsszF/5VX8OtVVhi8IRmbAw9xST6KJmmvPW84/Obkw7gdReBNZi40AXc2IRIBgQhaZaL6bo0=
Message-ID: <170fa0d20704160748m60503365q5be2beba591a9f@mail.gmail.com>
Date: Mon, 16 Apr 2007 10:48:49 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "James Lentini" <jlentini@netapp.com>
Subject: Re: [NFS] Merge plans for RPC/RDMA? (Was: Re: [PATCH 000 of 14] knfsd: Preparation for IPv6 support in NFS server.)
Cc: "Trond Myklebust" <trond.myklebust@fys.uio.no>, chuck.lever@oracle.com,
       NeilBrown <neilb@suse.de>, "Andrew Morton" <akpm@osdl.org>,
       "Roland Dreier" <rdreier@cisco.com>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Tom Tucker" <tom@opengridcomputing.com>,
       Thomas.Talpey@netapp.com, "Or Gerlitz" <ogerlitz@voltaire.com>
In-Reply-To: <Pine.LNX.4.64.0704161002200.7869@jlentini-linux.nane.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <170fa0d20704131347u4a28b5d1h1959227980449fbf@mail.gmail.com>
	 <1176502465.6394.26.camel@heimdal.trondhjem.org>
	 <170fa0d20704142040w204a715bgf5ce772e67126bbd@mail.gmail.com>
	 <Pine.LNX.4.64.0704161002200.7869@jlentini-linux.nane.netapp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, James Lentini <jlentini@netapp.com> wrote:
>
>
> On Sat, 14 Apr 2007, Mike Snitzer wrote:
>
> > I'm interested in understanding why the reluctance to push for a merge
> > now (let alone some months ago) given the various successes that have
> > been seen with the NFS/RDMA effort (Sandia, SC '06, as Chuck noted:
> > good performance at various test sites).  If the code is holding up
> > well why the delay in review and merging?  And rather than wait for
> > the remaining transport switch patches; why not look to merge all of
> > NFS/RDMA (client) work at the same time?
>
> There is no reluctance to submit the NFS-RDMA code for review. There
> have been several upstream changes to the NFS server recently. We
> (NetApp and Tom Tucker at OGC) are working on a new patchset for
> NFS-RDMA that is compatible with these changes. We are testing the
> code now.
>
> We will post the patches for review when we finish updating them.

Thanks for the clarification.  It was unfair of me to imply any amount
of "reluctance" to submit the NFS/RDMA code for review.  I was just
trying to gauge the "real soon now" type posts we've seen over the
past few months.  If anything I'd imagine the latest NFS churn has
given you additional incentive to merge.

Thanks for your continued hard work; NFS/RDMA looks to be a huge
improvement for modern NFS deployments.

regards,
Mike
