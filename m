Return-Path: <linux-kernel-owner+w=401wt.eu-S1765832AbYBTVQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765832AbYBTVQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761601AbYBTVOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:14:47 -0500
Received: from mx2.netapp.com ([216.240.18.37]:34660 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760256AbYBTVOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:14:37 -0500
X-IronPort-AV: E=Sophos;i="4.25,382,1199692800"; 
   d="scan'208";a="154507458"
Subject: Re: [PATCH] nfs: fix sparse warnings
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1203541385.25307.29.camel@brick>
References: <1203538246.25307.14.camel@brick>
	 <1203540206.17505.3.camel@heimdal.trondhjem.org>
	 <1203541385.25307.29.camel@brick>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Wed, 20 Feb 2008 16:14:33 -0500
Message-Id: <1203542073.18167.0.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 20 Feb 2008 21:14:34.0851 (UTC) FILETIME=[97AE7330:01C87405]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-20 at 13:03 -0800, Harvey Harrison wrote:
> fs/nfs/nfs4state.c:788:34: warning: Using plain integer as NULL pointer
> fs/nfs/delegation.c:52:34: warning: Using plain integer as NULL pointer
> fs/nfs/idmap.c:312:12: warning: Using plain integer as NULL pointer
> fs/nfs/callback_xdr.c:257:6: warning: Using plain integer as NULL pointer
> fs/nfs/callback_xdr.c:270:6: warning: Using plain integer as NULL pointer
> fs/nfs/callback_xdr.c:281:6: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Rollup patches 1-4.
>  fs/nfs/callback_xdr.c |    6 +++---
>  fs/nfs/delegation.c   |    2 +-
>  fs/nfs/idmap.c        |    2 +-
>  fs/nfs/nfs4state.c    |    2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)

Thanks! I'll apply...

Cheers
  Trond
