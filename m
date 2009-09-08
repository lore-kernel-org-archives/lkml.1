Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbZIHWvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbZIHWvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZIHWvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:51:38 -0400
Received: from waste.org ([173.11.57.241]:41795 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbZIHWvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:51:37 -0400
Subject: Re: [PATCH] tmpfs: depend on shmem
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0909082111400.11481@sister.anvils>
References: <Pine.LNX.4.64.0909082111400.11481@sister.anvils>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 17:51:19 -0500
Message-Id: <1252450279.7145.82.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 21:25 +0100, Hugh Dickins wrote:
> CONFIG_SHMEM off gives you (ramfs masquerading as) tmpfs, even when
> CONFIG_TMPFS is off: that's a little anomalous, and I'd intended to
> make more sense of it by removing CONFIG_TMPFS altogether, always
> enabling its code when CONFIG_SHMEM; but so many defconfigs have
> CONFIG_SHMEM on CONFIG_TMPFS off that we'd better leave that as is.
> 
> But there is no point in asking for CONFIG_TMPFS if CONFIG_SHMEM is
> off: make TMPFS depend on SHMEM, which also prevents TMPFS_POSIX_ACL
> shmem_acl.o being pointlessly built into the kernel when SHMEM is off.

Fair enough.

> And a selfish change, to prevent the world from being rebuilt when I
> switch between CONFIG_SHMEM on and off: the only CONFIG_SHMEM in the
> header files is mm.h shmem_lock() - give that a shmem.c stub instead.

Might as well, on the principle of one less ifdef.

> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
http://selenic.com : development and support for Mercurial and Linux


