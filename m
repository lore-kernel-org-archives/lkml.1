Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYLSKjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYLSKjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 05:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYLSKjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 05:39:46 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:32284 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567AbYLSKjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 05:39:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACqESkl5LB1f/2dsb2JhbAC+UViQXYMG
X-IronPort-AV: E=Sophos;i="4.36,247,1228051800"; 
   d="scan'208";a="279233115"
Date: Fri, 19 Dec 2008 21:39:38 +1100
From: Dave Chinner <david@fromorbit.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for December 18 (patch: kernel-doc notation)
Message-ID: <20081219103938.GD17177@disturbed>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	akpm <akpm@linux-foundation.org>
References: <20081218230637.c879a046.sfr@canb.auug.org.au> <20081218161437.fe2d2675.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218161437.fe2d2675.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 04:14:37PM -0800, Randy Dunlap wrote:
> fs/inode.c and mm/filemap.c need kernel-doc fixes.
> 
> What tree were these merged into for linux-next?

The fs/inode.c one ended up going through the XFS tree because
of the XFs code dependent on it....

> How do I get these doc fixes merged?  (2 patches below)

Perhaps best to go through the VFS tree for fs/inode.c changes.

> ---
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix fs/inode.c kernel-doc function parameters:
> 
> Warning(linux-next-20081218//fs/inode.c:120): No description found for parameter 'sb'
> Warning(linux-next-20081218//fs/inode.c:120): No description found for parameter 'inode'
> Warning(linux-next-20081218//fs/inode.c:588): No description found for parameter 'sb'
> Warning(linux-next-20081218//fs/inode.c:588): No description found for parameter 'inode'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Dave Chinner <david@fromorbit.com>

Looks fine to me.

Reviewed-by: Dave Chinner <david@fromorbit.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
