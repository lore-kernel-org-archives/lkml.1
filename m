Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZABBUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZABBUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 20:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZABBT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 20:19:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47773 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbZABBT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 20:19:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090101235332.GA31840@fieldses.org>
References: <20090101235332.GA31840@fieldses.org> <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@lst.de>, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by sys_faccessat() [ver #2]
Date: Fri, 02 Jan 2009 01:19:12 +0000
Message-ID: <29449.1230859152@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> Hm.  newpynfs is also giving me failures having to do with the v4
> server's permissions-checking.  I'll investigate, but is it possible
> nfsd also needs a fix?

It's possible.  Have you seen whether this patch fixes those failures also?
nfsd uses this facility also.

David
