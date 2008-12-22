Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYLVXVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYLVXVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYLVXV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:21:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58606 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbYLVXV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:21:28 -0500
Date: Mon, 22 Dec 2008 18:21:25 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "C. Scott Ananian" <cscott@laptop.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
Message-ID: <20081222232125.GA25334@infradead.org>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com> <c6d9bea0812181536p2a3aaeacmbd6af0474279b7b@mail.gmail.com> <1229916126.29604.47.camel@localhost.localdomain> <c6d9bea0812221159h30b0501dm8f48d93e0cb53bfa@mail.gmail.com> <20081222210410.GL28946@ZenIV.linux.org.uk> <c6d9bea0812221508n75f03ebdsff5bcbabe56eae56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6d9bea0812221508n75f03ebdsff5bcbabe56eae56@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 06:08:08PM -0500, C. Scott Ananian wrote:
> That's not correct, as /proc/self/fd/<num> and the getcwd syscall make
> clear.

No.  These take a file descriptor into account, which _does_ have a
unique path.

> struct inode has a i_dentry member, and via its d_parent links
> you can reconstruct the path, as __d_path in fs/dcache.c does.

reconstruct _a_ path inside the same filesystem, ignoring which link is
wanted, and inside which mount.

