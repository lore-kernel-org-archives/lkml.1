Return-Path: <linux-kernel-owner+w=401wt.eu-S1751817AbXBVUDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbXBVUDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbXBVUDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:03:08 -0500
Received: from lixom.net ([66.141.50.11]:57837 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbXBVUDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:03:07 -0500
Date: Thu, 22 Feb 2007 14:13:15 -0600
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfs: init req_lock in nfs_alloc_inode
Message-ID: <20070222201315.GA14686@lixom.net>
References: <20070216170532.GA4895@lixom.net> <1171984200.6271.15.camel@heimdal.trondhjem.org> <20070220172345.GA19249@lixom.net> <1172018238.6421.26.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172018238.6421.26.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 07:37:18PM -0500, Trond Myklebust wrote:

> Looks like we need a check in nfs_getattr() for a regular file. It makes
> no sense to call nfs_sync_mapping_range() on anything else. I think that
> should fix your problem: it will stop the NFS client from interfering
> with dirty pages on that inode's mapping.

Yep, that works here. I also verified that my previous patch really
didn't change the behaviour. I wonder why it did once. Probably just
pure luck with memory contents.

> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date: Tue, 20 Feb 2007 19:28:07 -0500
> Subject: No Subject
> 
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
