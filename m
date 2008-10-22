Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbYJVE0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbYJVE0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 00:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbYJVE0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 00:26:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20551 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbYJVE0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 00:26:11 -0400
Date: Tue, 21 Oct 2008 21:25:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       dwmw2@infradead.org
Subject: Re: linux-next: Tree for October 21 (jffs2)
Message-Id: <20081021212544.06588df7.randy.dunlap@oracle.com>
In-Reply-To: <20081021195109.ed83b102.sfr@canb.auug.org.au>
References: <20081021195109.ed83b102.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 19:51:09 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Today's tree will not build for powerpc allyesconfig (libc aborts the
> link due to a free() problem), sparc(32) defconfig and probably some
> other configurations.
> 
> I am no longer commenting on conflicts that are clearly just caused by
> slight differences in what has been merged into Linus' tree and
> linux-next or conflicts caused by further changes in the linux-next after
> a subset of a tree has been merged.

linux-next-20081021/fs/jffs2/nodemgmt.c:265: error: 'struct jffs2_sb_info' has no member named 'wbuf_ofs'
linux-next-20081021/fs/jffs2/nodemgmt.c:265: error: 'struct jffs2_sb_info' has no member named 'wbuf_len'
linux-next-20081021/fs/jffs2/nodemgmt.c:266: error: 'struct jffs2_sb_info' has no member named 'wbuf_ofs'


---
~Randy
