Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbZDBRlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbZDBRlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbZDBRlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:41:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52168 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbZDBRlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:41:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200904030431.04079.nickpiggin@yahoo.com.au>
References: <200904030431.04079.nickpiggin@yahoo.com.au> <200904030353.17713.nickpiggin@yahoo.com.au> <200904030315.03606.nickpiggin@yahoo.com.au> <7249.1238692155@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/43] FS-Cache: Recruit a couple of page flags for cache management [ver #46]
Date: Thu, 02 Apr 2009 18:40:57 +0100
Message-ID: <7516.1238694057@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Well in theory I still think it would be cleanest to modify buffer to
> play more nicely with it. But maybe that ends up being harder to
> distinguish the 3 cases of attached metadata on the page. I don't know,
> you haven't posted any isofs code so either way it is inappropriate to
> use up this extra page flag here.
> 
> Is isofs cache worth a page flag?

Well, isofs was something I wanted at the time.

Besides, as I said NFS uses PG_private for its own purposes, and entangling
the two wasn't the most fun I've had.  Trond didn't like it either.

David
