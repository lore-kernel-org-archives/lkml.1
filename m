Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbYLVVEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbYLVVEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYLVVEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:04:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48924 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbYLVVEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:04:13 -0500
Date: Mon, 22 Dec 2008 21:04:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "C. Scott Ananian" <cscott@laptop.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
Message-ID: <20081222210410.GL28946@ZenIV.linux.org.uk>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com> <c6d9bea0812181536p2a3aaeacmbd6af0474279b7b@mail.gmail.com> <1229916126.29604.47.camel@localhost.localdomain> <c6d9bea0812221159h30b0501dm8f48d93e0cb53bfa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6d9bea0812221159h30b0501dm8f48d93e0cb53bfa@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 02:59:37PM -0500, C. Scott Ananian wrote:
> > 2) major vfs and every FS redesign me thinks.
> 
> I'm not convinced of that.  I'm pretty certain one could export
> symlinks /proc/<pid>/mountinfo/<dev>/<inode> -> <absolute path in
> processes' namespace> with very little trouble, and no violence done
> to the VFS, which already has an iget() function which does the heavy
> lifting.

There is no such thing as absolute path of inode *anywhere*, process
namespace or not.  Not on any UNIX.  Period.  End of story.

Al, once again astonished by the ability of desktop developers to
post from the alternative realities they apparently inhabit...
