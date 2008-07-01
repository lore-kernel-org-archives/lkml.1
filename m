Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbYGAOXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbYGAOXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbYGAOX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:23:28 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56335 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbYGAOX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:23:27 -0400
To: mtk.manpages@googlemail.com
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, drepper@redhat.com, mtk.manpages@gmail.com
In-reply-to: <cfd18e0f0807010709veab05adg2c6566a79b7baabb@mail.gmail.com>
	(mtk.manpages@googlemail.com)
Subject: Re: [patch 1/4] vfs: utimes: move owner check into inode_change_ok()
References: <20080701130125.529844715@szeredi.hu>
	 <20080701130150.978939061@szeredi.hu> <cfd18e0f0807010709veab05adg2c6566a79b7baabb@mail.gmail.com>
Message-Id: <E1KDglP-0005Rx-Fh@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 01 Jul 2008 16:23:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Tue, 1 Jul 2008, Michael Kerrisk wrote:
> On Tue, Jul 1, 2008 at 3:01 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> >
> > Add a new ia_valid flag: ATTR_TIMES_SET, to handle the
> > UTIMES_OMIT/UTIMES_NOW and UTIMES_NOW/UTIMES_OMIT cases.  In these
> > cases neither ATTR_MTIME_SET nor ATTR_ATIME_SET is in the flags, yet
> > the POSIX draft specifies that permission checking is performed the
> > same way as if one or both of the times was explicitly set to a
> > timestamp.
> >
> > See the path "vfs: utimensat(): fix error checking for
> > {UTIME_NOW,UTIME_OMIT} case" by Michael Kerrisk for the patch
> > introducing this behavior.
> >
> > This is a cleanup, as well as allowing filesystems (NFS/fuse/...) to
> > perform their own permission checking instead of the default.
> 
> What kernel version/tree is this patch against?

Against latest git.  2.6.26-rc8-git2 seems to be recent enough.

Miklos
