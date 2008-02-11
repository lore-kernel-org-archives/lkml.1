Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYBKGZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYBKGZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 01:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbYBKGYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 01:24:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50199 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbYBKGYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 01:24:47 -0500
Date: Sun, 10 Feb 2008 22:22:51 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.24.2
Message-ID: <20080211062251.GB8476@kroah.com>
References: <20080211062224.GA8476@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211062224.GA8476@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index e6a6eec..6f79564 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 24
-EXTRAVERSION = .1
+EXTRAVERSION = .2
 NAME = Err Metey! A Heury Beelge-a Ret!
 
 # *DOCUMENTATION*
diff --git a/fs/splice.c b/fs/splice.c
index 36fdc61..e313478 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1239,7 +1239,7 @@ static int get_iovec_page_array(const struct iovec __user *iov,
 		if (unlikely(!len))
 			break;
 		error = -EFAULT;
-		if (unlikely(!base))
+		if (!access_ok(VERIFY_READ, base, len))
 			break;
 
 		/*
