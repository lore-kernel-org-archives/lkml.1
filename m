Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYLSSYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYLSSYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 13:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYLSSYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 13:24:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58406 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbYLSSYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 13:24:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <7A24DF798E223B4C9864E8F92E8C93EC01AAF504@SACMVEXC1-PRD.hq.netapp.com>
References: <7A24DF798E223B4C9864E8F92E8C93EC01AAF504@SACMVEXC1-PRD.hq.netapp.com>
To: "Muntz, Daniel" <Dan.Muntz@netapp.com>
Cc: dhowells@redhat.com, "Andrew Morton" <akpm@linux-foundation.org>,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org,
       steved@redhat.com, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com
Subject: Re: Pull request for FS-Cache, including NFS patches
Date: Fri, 19 Dec 2008 18:24:19 +0000
Message-ID: <12342.1229711059@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Muntz, Daniel <Dan.Muntz@netapp.com> wrote:

> AFS was designed to support local disk cache, so with callbacks you can get a
> consistent system.

It's less the callbacks and more the data version number that's important.

> I'll ass-u-me that Linux flavors of AFS have callbacks. 

They do.

> It should be possible to *integrate* NFSv4.x with FS-Cache similarly (i.e., I
> don't think you could drop it in as a 'black-box' without breaking something,
> unless you explicitly build an independent proxy cache server).

NFSv4 has equivalents of both the data version number and callbacks.

David
