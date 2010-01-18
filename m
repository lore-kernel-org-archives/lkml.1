Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268Ab0AROea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0AROea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948Ab0AROe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:34:29 -0500
Received: from lazybastard.de ([212.112.238.170]:57985 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab0AROe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:34:29 -0500
Date: Mon, 18 Jan 2010 15:34:15 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: vfs tree build warning
Message-ID: <20100118143415.GA5700@logfs.org>
References: <20100118131128.a09d1021.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100118131128.a09d1021.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 January 2010 13:11:28 +1100, Stephen Rothwell wrote:
> 
> Today's linux-next build (x86_64_allmodconfig) produced this warning:
> 
> fs/logfs/inode.c:399: warning: initialization from incompatible pointer type
> 
> Introduced by commit bc39e28236344af617473df80abb7de43176511e ("pass
> writeback_control to ->write_inode") from the vfs tree interacting with
> commit 5db53f3e80dee2d9dff5e534f9e9fe1db17c9936 ("[LogFS] add new flash
> file system") from the logfs tree.
> 
> This will need a fixup patch (see below) which I can carry in the
> linux-next tree.  There may, of course, be a better fix (which I can
> carry if someone sends it to me).

Looks good enough for me for now.  Next week, after returning from
vacation, I'll have a closer look and update the logfs tree.

Thank you, Stephen!

Jörn

-- 
Joern's library part 7:
http://www.usenix.org/publications/library/proceedings/neworl/full_papers/mckusick.a
