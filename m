Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYE3UJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYE3UJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYE3UI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:08:59 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42520 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbYE3UI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:08:58 -0400
To: matthew@wil.cx
CC: miklos@szeredi.hu, mtk.manpages@googlemail.com, drepper@redhat.com,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20080530193207.GB28074@parisc-linux.org> (message from Matthew
	Wilcox on Fri, 30 May 2008 13:32:07 -0600)
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
References: <482D4665.4050401@gmail.com> <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com> <E1K27bZ-0002Gk-3b@pomaz-ex.szeredi.hu> <cfd18e0f0805301124o5f217dden10726b268d05d81a@mail.gmail.com> <E1K2ABK-0002ck-UT@pomaz-ex.szeredi.hu> <20080530193207.GB28074@parisc-linux.org>
Message-Id: <E1K2Atg-0002io-0v@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 30 May 2008 22:08:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > For 2) you can just use permission() instead of vfs_permission() which
> > is exactly the same in this case (and consolidated into a common
> > function later in the vfs-cleanups tree).
> 
> Miklos, don't delude people into thinking the vfs-cleanups tree is ever
> going to get merged in its current state.  Al's NAKed the path_* stuff,
> Christoph's NAKed it too.

Actually, the cleanup patches which I'm asking Michael to base his
patches on were not NAKed.

And Michael is not even working against the vfs-cleanups tree, but
rather just a couple of these utimes cleanup patches, none of which
are controversial like the path_* stuff.  But even if he was working
against the vfs-cleanups tree it wouldn't matter, since porting
patches to/from the path_* API is trivial.

>  Ignoring them and putting up a VFS tree of your own is not going to
> help matters.

Do please tell me how else should I work?  I post patches for review,
gradually, not as a 100 patch series, when we manage to submit
apparmor.  That far easier for people to handle, and sure enough I get
comments are testing for this stuff.

As for Al's NAK: the only alternative suggestion he has been able to
come up is to move the security hooks into callers.  And that has been
NAKed (not surprisingly) by the selinux folks.  And there's nothing
actually _wrong_ with those patches, they don't add complexity
(actually they remove complexity), they don't slow down the kernel,
and they even fix some bugs.  Now what the hell more do we need?

Thanks,
Miklos
