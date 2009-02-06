Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbZBFVvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbZBFVvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 16:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZBFVvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 16:51:23 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:60716 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZBFVvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 16:51:22 -0500
Subject: Re: [GIT PULL] Btrfs updates for 2.6.29-rc
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0902060851270.3048@localhost.localdomain>
References: <1233937349.17551.18.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0902060851270.3048@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 16:51:07 -0500
Message-Id: <1233957067.10366.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.498CB0CF.0045:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 08:53 -0800, Linus Torvalds wrote:
> 
> On Fri, 6 Feb 2009, Chris Mason wrote:
> > 
> > Here's the shortlog:
> 
> Diffstats too, please.
> 

Whoops, here we go:

fs/btrfs/Kconfig        |   13 ++
 fs/btrfs/async-thread.c |   60 +++++++-
 fs/btrfs/ctree.c        |  259 ++++++++++++++++++++++++++++--
 fs/btrfs/ctree.h        |    5 +-
 fs/btrfs/disk-io.c      |   16 ++-
 fs/btrfs/extent-tree.c  |  397 +++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/extent_io.c    |   39 ++---
 fs/btrfs/extent_io.h    |   16 ++-
 fs/btrfs/inode.c        |   57 ++++++-
 fs/btrfs/locking.c      |  208 ++++++++++++++++++++++--
 fs/btrfs/locking.h      |    6 +
 fs/btrfs/ref-cache.c    |    1 +
 fs/btrfs/ref-cache.h    |    1 -
 fs/btrfs/tree-defrag.c  |    1 +
 fs/btrfs/tree-log.c     |    4 +
 fs/btrfs/volumes.c      |   11 +-
 fs/btrfs/xattr.c        |   34 ++++-
 fs/btrfs/xattr.h        |    2 +
 18 files changed, 996 insertions(+), 134 deletions(-)

This time around, there are actually lots of comments added.

-chris


