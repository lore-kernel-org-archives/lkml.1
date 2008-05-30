Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbYE3Tcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbYE3Tcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 15:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYE3TcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 15:32:24 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45135 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYE3TcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 15:32:23 -0400
Date: Fri, 30 May 2008 13:32:07 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: mtk.manpages@googlemail.com, drepper@redhat.com, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
Message-ID: <20080530193207.GB28074@parisc-linux.org>
References: <482D4665.4050401@gmail.com> <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com> <E1K27bZ-0002Gk-3b@pomaz-ex.szeredi.hu> <cfd18e0f0805301124o5f217dden10726b268d05d81a@mail.gmail.com> <E1K2ABK-0002ck-UT@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K2ABK-0002ck-UT@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 09:22:30PM +0200, Miklos Szeredi wrote:
> For 2) you can just use permission() instead of vfs_permission() which
> is exactly the same in this case (and consolidated into a common
> function later in the vfs-cleanups tree).

Miklos, don't delude people into thinking the vfs-cleanups tree is ever
going to get merged in its current state.  Al's NAKed the path_* stuff,
Christoph's NAKed it too.  Ignoring them and putting up a VFS tree of
your own is not going to help matters.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
