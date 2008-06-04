Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbYFDFfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbYFDFfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 01:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYFDFfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 01:35:23 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54584 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYFDFeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 01:34:37 -0400
To: raven@themaw.net
CC: viro@ZenIV.linux.org.uk, jmoyer@redhat.com, torvalds@linux-foundation.org,
       miklos@szeredi.hu, jesper@krogh.cc, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <1212547323.3146.45.camel@raven.themaw.net> (message from Ian
	Kent on Wed, 04 Jun 2008 10:42:02 +0800)
Subject: Re: Linux 2.6.26-rc4
References: <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212509263.3025.66.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
	 <1212513189.3025.101.camel@raven.themaw.net>
	 <20080603173029.GD28946@ZenIV.linux.org.uk>
	 <x49ej7ejtry.fsf@segfault.boston.devel.redhat.com>
	 <20080603191859.GG28946@ZenIV.linux.org.uk>
	 <x49abi2jnwf.fsf@segfault.boston.devel.redhat.com>
	 <20080603230026.GH28946@ZenIV.linux.org.uk> <1212547323.3146.45.camel@raven.themaw.net>
Message-Id: <E1K3ldP-0007pW-OA@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jun 2008 07:34:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps, if we didn't use /etc/mtab anywhere.
> It would make a difference if we could "mount" /proc/mounts onto a file
> such as /etc/mtab and everyone always did that.

That's actually remarkably close to being possible.  Loopback mounts
have already been fixed not to rely on /etc/mtab.  The only major
piece missing is "user" mounts, and there's already a patchset for
that waiting for review by the VFS maintainers.  After that, it's just
a "simple" issue of fixing up all the userspace pieces.  Could be
finished in the next decade, possibly ;)

Miklos
