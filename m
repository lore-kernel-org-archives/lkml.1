Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbZDTFTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbZDTFTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 01:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZDTFT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 01:19:27 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:61115 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZDTFT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 01:19:27 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: Problems with default ACLs over NFS 
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, " " <jamagallon@ono.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Trond.Myklebust@netapp.com, lists@fuchsschwanzdomain.de
In-Reply-To: <49EBFD18.4070607@suse.de>
References: <20090323222427.00bb24e7@werewolf.home> <20090326170513.4e7d377a.akpm@linux-foundation.org> <18513.1238194255@jrobl> <49EBFD18.4070607@suse.de>
Date: Mon, 20 Apr 2009 14:17:36 +0900
Message-ID: <7064.1240204656@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Suresh Jayaraman:
> The following patch from Trond should fix this issue, I think.
> 
> 
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date: Wed, 15 Apr 2009 13:58:45 -0400
> Subject: [PATCH] NFS: Fix the XDR iovec calculation in nfs3_xdr_setaclargs
> 
> Commit ae46141ff08f1965b17c531b571953c39ce8b9e2 (NFSv3: Fix posix ACL code)
> introduces a bug in the calculation of the XDR header iovec. In the case
> where we are inlining the acls, we need to adjust the length of the iovec
> req->rq_svec, in addition to adjusting the total buffer length.

Thanx.
But which tree is this patch applied?


J. R. Okajima
