Return-Path: <linux-kernel-owner+w=401wt.eu-S1751287AbXA2P4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbXA2P4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbXA2P4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:56:00 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:24983 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbXA2Pz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:55:59 -0500
Date: Mon, 29 Jan 2007 19:02:50 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] lutimesat: actual syscall and wire-up on i386
Message-ID: <20070129160250.GA6021@localhost.sw.ru>
References: <20070126112345.GC11128@localhost.sw.ru> <20070126123903.046aaa5e.akpm@osdl.org> <45BA6860.6040007@redhat.com> <20070129110509.GA13096@localhost.sw.ru> <45BE0D98.7020005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BE0D98.7020005@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 07:07:04AM -0800, Ulrich Drepper wrote:
> Alexey Dobriyan wrote:
> > What do you mean by "filesystems cannot support lutimes"? Filesystems
> > that don't have on-disk timestamps for symlinks?
> 
> Yes.

Checked to be sure, on ext2, ext3, reiserfs, XFS symlink timestamps
stick across mounts/umounts.

Also, looking at disk inode structures of UFS, SysV, JFFS2, GFS2, EFS, I
think they should handle lutimesat(2) just fine.

