Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZGWQQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZGWQQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 12:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZGWQQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 12:16:39 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47545 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbZGWQQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 12:16:38 -0400
Subject: Re: [PATCH] jfs: Fix early release of acl in jfs_get_acl
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
       Andy Whitcroft <apw@canonical.com>, Christophe Dumez <dchris@gmail.com>
In-Reply-To: <4A687796.80200@canonical.com>
References: <4A687796.80200@canonical.com>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 11:16:32 -0500
Message-Id: <1248365792.29722.3.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 16:45 +0200, Stefan Bader wrote:
> Commit 073aaa1b142461d91f83da66db1184d7c1b1edea "helpers for acl
> caching + switch to those" introduced new helper functions for
> acl handling but seems to have introduced a regression for jfs as the
> acl is released before returning it to the caller, instead of
> leaving this for the caller to do.
> This causes the acl object to be used after freeing it, leading
> to kernel panics in completely different places.

This looks good.  Thanks much!  I'll get it upstream as soon as
possible.

> Thanks to Christophe Dumez for reporting and bisecting into this.
> 
> Reported-by: Christophe Dumez <dchris@gmail.com>
> Tested-by: Christophe Dumez <dchris@gmail.com>
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> Acked-by: Andy Whitcroft <apw@canonical.com>
> ---
>   fs/jfs/acl.c |    4 +---
>   1 files changed, 1 insertions(+), 3 deletions(-)

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

