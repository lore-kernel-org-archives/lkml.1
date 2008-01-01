Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbYAAHnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbYAAHnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 02:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYAAHnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 02:43:41 -0500
Received: from po-out-1718.google.com ([72.14.252.158]:61733 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYAAHnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 02:43:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=miFrkwQqgB7v+tdz5HRbBLtIDBvrdgGK7s7okzzZRVxAoK+KFH8Ib+dTO9yxsXU0a5t9I9G1Iu2Nosv6MpWXAecEFYihkLf7cLKimE4FR4az6uHph6LFGZOqiaVnLYyW8thQmDPVf/0SnG4Xu7EjfZ5E7/24RAx94LZh9kNC5Tk=
Date: Tue, 1 Jan 2008 15:43:52 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: [Patch 8/8] Remove 'TOPDIR' from the Top Makefile
Message-ID: <20080101074352.GI2496@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101071311.GA2496@hacking>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


TOPDIR is obsolete, thus can be removed.
This patch removes TOPDIR from the top Makefile.

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/Makefile b/Makefile
index fbb8dfc..c892d14 100644
--- a/Makefile
+++ b/Makefile
@@ -148,15 +148,13 @@ _all: modules
 endif
 
 srctree		:= $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR))
-TOPDIR		:= $(srctree)
-# FIXME - TOPDIR is obsolete, use srctree/objtree
 objtree		:= $(CURDIR)
 src		:= $(srctree)
 obj		:= $(objtree)
 
 VPATH		:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))
 
-export srctree objtree VPATH TOPDIR
+export srctree objtree VPATH
 
 
 # SUBARCH tells the usermode build what the underlying arch is.  That is set
