Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbYAXWCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbYAXWCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbYAXWCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:02:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35908 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755654AbYAXWCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:02:41 -0500
Date: Thu, 24 Jan 2008 13:57:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 19/26] mount options: fix jfs
Message-Id: <20080124135713.76523ba6.akpm@linux-foundation.org>
In-Reply-To: <1201209301.32767.4.camel@norville.austin.ibm.com>
References: <20080124193341.166753833@szeredi.hu>
	<20080124193445.807705054@szeredi.hu>
	<1201209301.32767.4.camel@norville.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Jan 2008 15:15:01 -0600 Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> On Thu, 2008-01-24 at 20:34 +0100, Miklos Szeredi wrote:
> > plain text document attachment (jfs_opts.patch)
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add iocharset= and errors= options to /proc/mounts for jfs
> > filesystems.
> > 
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> 
> Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> 
> Andrew,
> Would you like me to add this to the jfs git tree, or would you like to
> handle these patches as a set?
> 

My usual algorithm here is to

1: queue all the patches and send the ones which have a maintainer to
   that maintainer until he merges it.

2: If the patches have a dependency upon (say) a VFS patch then I'll
   merge the VFS patch and will then goto 1.

I don't think this particular patch has a VFS depencency so sure, merge
away.  You'll probably see that I merged it anyway, but I'll drop it again
when I see it turn up in your tree (I used to resync with the git trees
at least daily, but I now do this far less frequently because it is such
torture because everyone is paddling in everyone else's puddle).
