Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737Ab0AREeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0AREeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 23:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715Ab0AREeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 23:34:05 -0500
Received: from cobra.newdream.net ([66.33.216.30]:52226 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab0AREeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 23:34:00 -0500
Date: Sun, 17 Jan 2010 20:34:29 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: vfs tree build warning
In-Reply-To: <20100118131139.1ef42c6f.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.1001172032590.16533@cobra.newdream.net>
References: <20100118131139.1ef42c6f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010, Stephen Rothwell wrote:
> Hi Al,
> 
> Today's linux-next build (x86_64_allmodconfig) produced this warning:
> 
> fs/ceph/super.c:216: warning: initialization from incompatible pointer type
> 
> Introduced by commit bc39e28236344af617473df80abb7de43176511e ("pass
> writeback_control to ->write_inode") from the vfs tree interacting with
> commit 16725b9d2a2e3d0fd2b0034482e2eb0a2d78050f ("ceph: super.c") from
> the ceph tree.
> 
> This will need a fixup patch (see below) which I can carry in the
> linux-next tree.  There may, of course, be a better fix (which I can
> carry if someone sends it to me).

I can put this in the for-next branch of the ceph tree.

Thanks-
sage
