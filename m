Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbXFAW4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbXFAW4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXFAWzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:55:52 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:35836 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634AbXFAWzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:55:51 -0400
Date: Fri, 1 Jun 2007 18:55:49 -0400
From: Kyle McMartin <kyle@parisc-linux.org>
To: Byron Stanoszek <bstanoszek@comtime.com>
Cc: Kyle McMartin <kyle@parisc-linux.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Chris Zankel <chris@zankel.net>, parisc-linux@lists.parisc-linux.org
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
Message-ID: <20070601225549.GD7714@fattire.cabal.ca>
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com> <20070531162021.4cd4e91a.akpm@linux-foundation.org> <20070601113840.813463db.sfr@canb.auug.org.au> <20070601030754.GB14217@fattire.cabal.ca> <Pine.LNX.4.64.0706011510220.26938@winds.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706011510220.26938@winds.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 03:17:03PM -0400, Byron Stanoszek wrote:
> These are octal values, so you really want to use 010000000 instead of
> 08000000. :-)
> 

Wow. I am totally a dumbass, I saw a 'x' there. Sigh.

diff --git a/include/asm-parisc/fcntl.h b/include/asm-parisc/fcntl.h
index 317851f..7089507 100644
--- a/include/asm-parisc/fcntl.h
+++ b/include/asm-parisc/fcntl.h
@@ -14,6 +14,7 @@
 #define O_DSYNC		01000000 /* HPUX only */
 #define O_RSYNC		02000000 /* HPUX only */
 #define O_NOATIME	04000000
+#define O_CLOEXEC	010000000	/* set close_on_exec */
 
 #define O_DIRECTORY	00010000 /* must be a directory */
 #define O_NOFOLLOW	00000200 /* don't follow links */
