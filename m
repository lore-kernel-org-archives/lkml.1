Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYLVWuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYLVWuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYLVWuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:50:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570AbYLVWuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:50:04 -0500
Date: Mon, 22 Dec 2008 14:49:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: sfr@canb.auug.org.au, david@fromorbit.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for December 18 (patch: kernel-doc notation)
Message-Id: <20081222144945.8ef2748e.akpm@linux-foundation.org>
In-Reply-To: <20081218161437.fe2d2675.randy.dunlap@oracle.com>
References: <20081218230637.c879a046.sfr@canb.auug.org.au>
	<20081218161437.fe2d2675.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 16:14:37 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> fs/inode.c and mm/filemap.c need kernel-doc fixes.
> 
> What tree were these merged into for linux-next?

I use git-blame.

> How do I get these doc fixes merged?  (2 patches below)
> 
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

>From the XFS tree:

commit 2cb1599f9b2ecdd7a9e59feeee647eb258966839
Author:     David Chinner <david@fromorbit.com>
AuthorDate: Thu Oct 30 17:32:23 2008 +1100
Commit:     Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
CommitDate: Thu Oct 30 17:32:23 2008 +1100

    Inode: Allow external initialisers


> ---
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix mm/filemap.c functions' kernel-doc:
> 
> Warning(/local/linsrc/linux-next-20081218//mm/filemap.c:575): No description found for parameter 'page'
> Warning(/local/linsrc/linux-next-20081218//mm/filemap.c:575): No description found for parameter 'waiter'
> Warning(/local/linsrc/linux-next-20081218//mm/filemap.c:2348): No description found for parameter 'mapping'
> Warning(/local/linsrc/linux-next-20081218//mm/filemap.c:2348): No description found for parameter 'index'
> Warning(/local/linsrc/linux-next-20081218//mm/filemap.c:2348): No description found for parameter 'source'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Dave Chinner <david@fromorbit.com>

That's no longer in linux-next.  I'd guess it was from the fs-cache
patches.

