Return-Path: <linux-kernel-owner+w=401wt.eu-S934500AbZJIVtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934500AbZJIVtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934469AbZJIVtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:49:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932877AbZJIVtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:49:21 -0400
Date: Fri, 9 Oct 2009 23:48:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, lftp@uniyar.ac.ru
Subject: Re: 2.6.31/lftp: WARNING: at drivers/char/tty_io.c:1267
 tty_open+0x439/0x4f0()
In-Reply-To: <alpine.DEB.2.00.0910091353230.3264@p34.internal.lan>
Message-ID: <alpine.LRH.2.00.0910092345210.12171@twin.jikos.cz>
References: <alpine.DEB.2.00.0910081304080.11551@p34.internal.lan> <alpine.DEB.2.00.0910091353230.3264@p34.internal.lan>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009, Justin Piszcz wrote:

> > [1628036.347248] WARNING: at drivers/char/tty_io.c:1267
> > tty_open+0x439/0x4f0()
> > [1628036.347250] Hardware name:
> > [1628036.347252] Pid: 23495, comm: lftp Not tainted 2.6.31 #3
> > [1628036.347254] Call Trace:
> > [1628036.347259]  [<ffffffff810b5733>] ? do_lookup+0x143/0x270
> > [1628036.347261]  [<ffffffff8126a8f9>] ? tty_open+0x439/0x4f0
> > [1628036.347265]  [<ffffffff8105473f>] ? warn_slowpath_common+0x6f/0xc0
> > [1628036.347267]  [<ffffffff8126a8f9>] ? tty_open+0x439/0x4f0
> > [1628036.347270]  [<ffffffff813af3c2>] ? sock_aio_read+0x142/0x150
> > [1628036.347274]  [<ffffffff810afd78>] ? chrdev_open+0x88/0x170
> > [1628036.347277]  [<ffffffff810c50a3>] ? mntput_no_expire+0x23/0xf0
> > [1628036.347279]  [<ffffffff810afcf0>] ? chrdev_open+0x0/0x170
> > [1628036.347282]  [<ffffffff810ab00a>] ? __dentry_open+0x9a/0x260
> > [1628036.347284]  [<ffffffff810b9ace>] ? do_filp_open+0x71e/0xac0
> > [1628036.347287]  [<ffffffff810bac3f>] ? vfs_ioctl+0x2f/0xb0
> > [1628036.347289]  [<ffffffff810bb143>] ? do_vfs_ioctl+0x3e3/0x570
> > [1628036.347302]  [<ffffffff810c357a>] ? alloc_fd+0x4a/0x140
> > [1628036.347304]  [<ffffffff810aae77>] ? do_sys_open+0x97/0x150
> > [1628036.347308]  [<ffffffff8102c42b>] ? system_call_fastpath+0x16/0x1b
> > [1628036.347309] ---[ end trace b69ffec827da9b40 ]---
> > 
> > The lftp process was running in a screened session.
> > 
> > Any thoughts as to the bug here?
> > 
> > Justin.
> 
> If anyone has replied--
> 
> Please CC me as I am not on the LKML list, thanks.

This should already be fixed by commit 0b5759c6. 

In case it is not, please shout.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

