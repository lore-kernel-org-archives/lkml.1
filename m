Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbZABTS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbZABTS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbZABTSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:18:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36172 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZABTSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:18:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090102164855.GB10465@fieldses.org>
References: <20090102164855.GB10465@fieldses.org> <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@lst.de>, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by sys_faccessat() [ver #2]
Date: Fri, 02 Jan 2009 19:18:02 +0000
Message-ID: <2352.1230923882@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> > Fix a regression in cap_capable() due to:
> > 
> > 	commit 5ff7711e635b32f0a1e558227d030c7e45b4a465
> 
> By the way, this should be 3b11a1decef07c19443d24ae926982bc8ec9f4c0,
> which is the patch that was committed by James Morris and is in Linus's
> tree.  I assume 5ff7711... is the commitid in your tree and that James
> applied it as a patch instead of pulling from you.

Erm...  Yes.  I'm not sure how my test tree has managed to come up with that
ID.  The 3b11 one is indeed correct.

David
